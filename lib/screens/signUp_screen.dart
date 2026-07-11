import 'package:flutter/material.dart';
import 'package:edu_wallet/screens/HomePage_screen.dart';
import '../services/auth_service_new.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    print('🔵 [SIGNUP] Sign up button pressed');
    
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || 
        _passwordController.text.isEmpty || _dobController.text.isEmpty) {
      print('❌ [SIGNUP] Empty fields detected');
      _showMessage('Please fill all fields', Colors.red);
      return;
    }

    if (_passwordController.text.length < 6) {
      print('❌ [SIGNUP] Password too short');
      _showMessage('Password must be at least 6 characters', Colors.red);
      return;
    }

    print('🔵 [SIGNUP] Starting signup process...');
    setState(() {
      _isLoading = true;
    });

    try {
      print('🔵 [SIGNUP] Creating AuthService instance...');
      final authService = AuthServiceNew();
      
      print('🔵 [SIGNUP] Calling signUpWithEmailAndPassword...');
      final userDetails = await authService.signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        dateOfBirth: _dobController.text,
      );
      
      print('🔵 [SIGNUP] Auth service returned: ${userDetails?.email}');
      
      if (userDetails != null) {
        print('✅ [SIGNUP] Signup successful! User: ${userDetails.name}');
        _showMessage('Account created successfully!', Colors.green);
        
        print('🔵 [SIGNUP] Navigating to home screen...');
        // Navigate to home screen
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) {
            print('🔵 [SIGNUP] Building HomePageScreen...');
            return const HomePageScreen();
          })
        );
        print('✅ [SIGNUP] Navigation completed');
      } else {
        print('❌ [SIGNUP] userDetails is null');
        _showMessage('Failed to create account - no user data returned', Colors.red);
      }
    } catch (e) {
      print('❌ [SIGNUP] Exception caught: $e');
      _showMessage('Signup error: ${e.toString()}', Colors.red);
    } finally {
      print('🔵 [SIGNUP] Cleaning up loading state...');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print('🔵 [SIGNUP] Loading state cleared');
      }
    }
  }

  void _showMessage(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    print('🔵 [SIGNUP] Signup screen build method called');
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false, // ✅ Prevents background from moving
      body: Stack(
        children: [
          // 🔹 Background image + gradient
          Container(
            width: double.infinity,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/lgo.png'),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                colors: [Color(0xFFF3E2B3), Color(0xFFE6C48F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🔹 Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.09,
                vertical: size.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                SizedBox(height: size.height * 0.02),

               Align(
                 alignment: Alignment.topLeft,
                 child: GestureDetector(
                 onTap: () => Navigator.pop(context),
                 child: Text(
                    "back",
                style: TextStyle(
                fontFamily: 'Irish Grover',
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.w600,
                color: Colors.black,
      ),
    ),
  ),
),

                SizedBox(height: size.height * 0.08),

                // Name field
                Text(
                  "Name",
                  style: TextStyle(
                    fontFamily: 'Ink Free',
                    fontSize: size.width * 0.063,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.025),

                Text(
                  "Date Of Birth",
                  style: TextStyle(
                    fontFamily: 'Ink Free',
                    fontSize: size.width * 0.063,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                TextField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.025),

                // Password field
                Text(
                  "Password",
                  style: TextStyle(
                    fontFamily: 'Ink Free',
                    fontSize: size.width * 0.063,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.025),

                // Email field
                Text(
                  "Email",
                  style: TextStyle(
                    fontFamily: 'Ink Free',
                    fontSize: size.width * 0.063,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),

                // Sign Up Button
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.2, vertical: size.height * 0.009),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.black)
                        : Text(
                            "Sign Up",
                            style: TextStyle(
                              fontFamily: "Jockey One",
                              color: Colors.black,
                              fontSize: size.width * 0.063,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: size.height * 0.03),
                // Extra bottom padding for keyboard
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
              ],
              ),
            ),
          ),

          // 🔹 Logo on top-right
          Positioned(
            top: 10,
            right: 40,
            child: SafeArea(
              child: Image.asset(
                'assets/images/logoo.png',
                height: size.height * 0.20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
