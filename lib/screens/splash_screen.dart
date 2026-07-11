import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('🔵 [SPLASH] Splash screen build method called');
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/bg_img.png'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [Color(0xFFF3E2B3), Color(0xFFE6C48F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          
          children: [
            Padding(padding: EdgeInsetsGeometry.fromLTRB(15, 15, 15, 15)),
            
            Image.asset(
              'assets/images/logoo.png',
              height: size.height * 0.54,
            ),
            const SizedBox(height: 65),
            ElevatedButton(
              onPressed: () {
                print('🔵 [SPLASH] Login button pressed, navigating to login screen');
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 3,
                padding:
                    EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(49),
                ),
              ),
              child:  Text(
                "Login",
                style: TextStyle(
                  fontFamily: "Jockey One",
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
