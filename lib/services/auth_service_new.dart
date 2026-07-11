import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthServiceNew {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<PigeonUserDetails?> signUpWithEmailAndPassword(
    String email, 
    String password, 
    String name,
    {String? dateOfBirth}
  ) async {
    print('🔵 [AUTH_NEW] Starting signup for email: $email');
    
    try {
      // Create Firebase Auth user
      print('🔵 [AUTH_NEW] Creating Firebase Auth user...');
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      if (result.user == null) {
        print('❌ [AUTH_NEW] No user returned from Firebase Auth');
        return null;
      }
      
      final user = result.user!;
      print('🔵 [AUTH_NEW] Firebase user created: ${user.uid}');
      
      // Update display name
      await user.updateDisplayName(name);
      
      // Create user details object
      final userDetails = PigeonUserDetails(
        uid: user.uid,
        name: name,
        email: email.trim(),
        dateOfBirth: dateOfBirth,
      );
      
      print('🔵 [AUTH_NEW] Creating Firestore document...');
      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userDetails.toMap());
      
      print('✅ [AUTH_NEW] Signup successful!');
      return userDetails;
      
    } on FirebaseAuthException catch (e) {
      print('❌ [AUTH_NEW] Firebase Auth Exception: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ [AUTH_NEW] Signup error: $e');
      throw 'Signup failed: $e';
    }
  }

  Future<PigeonUserDetails?> signInWithEmailAndPassword(
    String email, 
    String password
  ) async {
    print('🔵 [AUTH_NEW] Starting login for email: $email');
    
    try {
      // Authenticate with Firebase
      print('🔵 [AUTH_NEW] Authenticating with Firebase...');
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      if (result.user == null) {
        print('❌ [AUTH_NEW] No user returned from Firebase Auth');
        return null;
      }
      
      final user = result.user!;
      print('🔵 [AUTH_NEW] Firebase user authenticated: ${user.uid}');
      
      // Try to get user data from Firestore
      try {
        print('🔵 [AUTH_NEW] Fetching user document from Firestore...');
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (doc.exists && doc.data() != null) {
          print('🔵 [AUTH_NEW] User document found');
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          PigeonUserDetails userDetails = PigeonUserDetails.fromMap(data);
          print('✅ [AUTH_NEW] Login successful with existing data');
          return userDetails;
        } else {
          print('🔵 [AUTH_NEW] No user document found, creating new one...');
          // Create new user document
          final userDetails = PigeonUserDetails(
            uid: user.uid,
            name: user.displayName ?? user.email?.split('@')[0] ?? 'User',
            email: user.email!,
            dateOfBirth: null,
          );
          
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userDetails.toMap());
          
          print('✅ [AUTH_NEW] Login successful with new document');
          return userDetails;
        }
      } catch (firestoreError) {
        print('⚠️ [AUTH_NEW] Firestore error: $firestoreError');
        // Return user details from Auth only
        final userDetails = PigeonUserDetails(
          uid: user.uid,
          name: user.displayName ?? user.email?.split('@')[0] ?? 'User',
          email: user.email!,
          dateOfBirth: null,
        );
        print('✅ [AUTH_NEW] Login successful with fallback data');
        return userDetails;
      }
      
    } on FirebaseAuthException catch (e) {
      print('❌ [AUTH_NEW] Firebase Auth Exception: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ [AUTH_NEW] Login error: $e');
      throw 'Login failed: $e';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Sign out failed: $e';
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password is too weak (minimum 6 characters required).';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}