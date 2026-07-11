import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<PigeonUserDetails?> signUpWithEmailAndPassword(
    String email, 
    String password, 
    String name,
    {String? dateOfBirth}
  ) async {
    print('🔵 [AUTH] Starting signup for email: $email');
    
    try {
      print('🔵 [AUTH] Creating user with Firebase Auth...');
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      print('🔵 [AUTH] Firebase Auth result: ${result.user?.uid}');
      
      if (result.user != null) {
        print('🔵 [AUTH] Updating display name...');
        await result.user!.updateDisplayName(name);
        
        print('🔵 [AUTH] Creating user document in Firestore...');
        final userDetails = PigeonUserDetails(
          uid: result.user!.uid,
          name: name,
          email: email.trim(),
          dateOfBirth: dateOfBirth,
        );
        
        await _firestore
            .collection('users')
            .doc(result.user!.uid)
            .set(userDetails.toMap());
        
        print('✅ [AUTH] Signup successful! User: ${userDetails.name}');
        return userDetails;
      }
      
      print('❌ [AUTH] No user returned from Firebase Auth');
      return null;
    } on FirebaseAuthException catch (e) {
      print('❌ [AUTH] Firebase Auth Exception: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ [AUTH] Signup error: $e');
      throw 'Signup failed: $e';
    }
  }

  Future<PigeonUserDetails?> signInWithEmailAndPassword(
    String email, 
    String password
  ) async {
    print('🔵 [AUTH] Starting login for email: $email');
    
    try {
      print('🔵 [AUTH] Authenticating with Firebase Auth...');
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      print('🔵 [AUTH] Firebase Auth result: ${result.user?.uid}');
      
      if (result.user == null) {
        print('❌ [AUTH] No user returned from Firebase Auth');
        throw 'Authentication failed - no user returned';
      }
      
      final user = result.user!;
      print('🔵 [AUTH] User authenticated: ${user.email}');
      
      try {
        print('🔵 [AUTH] Fetching user data from Firestore...');
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        
        print('🔵 [AUTH] Document exists: ${userDoc.exists}');
        
        if (userDoc.exists) {
          print('🔵 [AUTH] User document found in Firestore');
          final data = userDoc.data();
          print('🔵 [AUTH] Raw data type: ${data.runtimeType}');
          print('🔵 [AUTH] Raw data: $data');
          
          if (data != null && data is Map<String, dynamic>) {
            print('🔵 [AUTH] Data is valid Map<String, dynamic>');
            final userDetails = PigeonUserDetails.fromMap(data);
            print('✅ [AUTH] Login successful with Firestore data: ${userDetails.email}');
            return userDetails;
          } else {
            print('⚠️ [AUTH] Data is not Map<String, dynamic>, type: ${data.runtimeType}');
          }
        }
        
        print('🔵 [AUTH] No user document found, creating new one...');
        final userDetails = PigeonUserDetails(
          uid: user.uid,
          name: user.displayName ?? user.email?.split('@')[0] ?? 'User',
          email: user.email!,
          dateOfBirth: null,
        );
        
        print('🔵 [AUTH] Creating document with data: ${userDetails.toMap()}');
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userDetails.toMap());
        
        print('✅ [AUTH] Login successful with new document created');
        return userDetails;
        
      } catch (firestoreError) {
        print('⚠️ [AUTH] Firestore error: $firestoreError');
        print('🔵 [AUTH] Error type: ${firestoreError.runtimeType}');
        print('🔵 [AUTH] Returning user details from Auth only');
        final fallbackUser = PigeonUserDetails(
          uid: user.uid,
          name: user.displayName ?? user.email?.split('@')[0] ?? 'User',
          email: user.email!,
          dateOfBirth: null,
        );
        print('🔵 [AUTH] Fallback user: ${fallbackUser.email}');
        return fallbackUser;
      }
      
    } on FirebaseAuthException catch (e) {
      print('❌ [AUTH] Firebase Auth Exception: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ [AUTH] Login error: $e');
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