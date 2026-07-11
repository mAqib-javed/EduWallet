import 'package:edu_wallet/screens/signUp_screen.dart';
import 'package:edu_wallet/screens/HomePage_screen.dart';
import 'package:flutter/material.dart';
import '../services/auth_service_new.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    print('🔵 [LOGIN] Login button pressed');
    
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      print('❌ [LOGIN] Empty fields detected');
      _showMessage('Please fill all fields', Colors.red);
      return;
    }

    print('🔵 [LOGIN] Starting login process...');
    setState(() {
      _isLoading = true;
    });

    try {
      print('🔵 [LOGIN] Creating AuthService instance...');
      final authService = AuthServiceNew();
      
      print('🔵 [LOGIN] Calling signInWithEmailAndPassword...');
      final userDetails = await authService.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      
      print('🔵 [LOGIN] Auth service returned: ${userDetails?.email}');
      
      if (userDetails != null) {
        print('✅ [LOGIN] Login successful! User: ${userDetails.name}');
        _showMessage('Login successful!', Colors.green);
        
        print('🔵 [LOGIN] Navigating to home screen...');
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            print('🔵 [LOGIN] Building HomePageScreen...');
            return const HomePageScreen();
          }),
        );
        print('✅ [LOGIN] Navigation completed');
      } else {
        print('❌ [LOGIN] userDetails is null');
        _showMessage('Login failed - no user data returned', Colors.red);
      }
    } catch (e) {
      print('❌ [LOGIN] Exception caught: $e');
      _showMessage('Login error: ${e.toString()}', Colors.red);
    } finally {
      print('🔵 [LOGIN] Cleaning up loading state...');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print('🔵 [LOGIN] Loading state cleared');
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
    print('🔵 [LOGIN] Login screen build method called');
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

                // Back button
                Align(
                 alignment: Alignment.topLeft,
                 child: GestureDetector(
                 onTap: () => Navigator.pop(context),
                 child:  Text(
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

                SizedBox(height: size.height * 0.04),

                // "Log In" text (Right-aligned)
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      fontFamily: 'Irish Grover',
                      fontSize: size.width * 0.125,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.11),

                // Email field
                Text(
                  "Email or Phone",
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
                SizedBox(height: size.height * 0.070),

                // Login Button
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.27, vertical: size.height * 0.013),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.black)
                        : Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: "Jockey One",
                              color: Colors.black,
                              fontSize: size.width * 0.063,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: size.height * 0.011),

                const Divider(
                  height: 20,
                  thickness: 1,
                  color: Colors.black,
                ),
                SizedBox(height: size.height * 0.014),

                // Signup section (❌ Removed const to fix error)
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Don’t have an account?",
                        style: TextStyle(
                          fontFamily: "Joti One",
                          fontSize: size.width * 0.042,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: size.height * 0.022),

                      // ✅ Fixed Sign Up button
                      ElevatedButton(
                       onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  SignUpScreen()),
    );
  },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.1, vertical: size.height * 0.012),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child:  Text(
                          "Sign Up",
                          style: TextStyle(
                            fontFamily: "Joti One",
                            color: Colors.black,
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Extra bottom padding for keyboard
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
              ],
              ),
            ),
          ),

          // 🔹 Logo on top-right
          Positioned(
            top: 01,
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
