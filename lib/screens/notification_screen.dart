import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/lgo.png'),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                colors: [Color(0xFFF5E6D3), Color(0xFFEBD2B0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.02),
                  
                  // Notifications title centered
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontFamily: 'Irish Grover',
                      fontSize: size.width * 0.067,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: size.height * 0.008),
                  Container(
                    width: size.width * 0.30,
                    height: 1,
                    color: Colors.black54,
                  ),
                  
                  SizedBox(height: size.height * 0.08),
                  
                  // 4 Notification cards with equal spacing
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNotificationCard(
                          size,
                          "You have been used 80% of your balance.",
                          "9:41 AM",
                        ),
                        _buildNotificationCard(
                          size,
                          "The amount of your balance had been changed.",
                          "8:30 AM",
                        ),
                        _buildNotificationCard(
                          size,
                          "New expenses had been added.",
                          "7:15 AM",
                        ),
                        _buildNotificationCard(
                          size,
                          "Allowances had been set.",
                          "6:00 AM",
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: size.height * 0.03),
                  
                  // Bottom navigation icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        icon: Image.asset(
                          'assets/icons/home.png',
                          width: 32,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.home, size: 32, color: Colors.black);
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/spent');
                        },
                        icon: Image.asset(
                          'assets/icons/dollars.png',
                          width: 32,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.attach_money, size: 32, color: Colors.black);
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/education');
                        },
                        icon: Image.asset(
                          'assets/icons/book.png',
                          width: 32,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.book, size: 32, color: Colors.black);
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ),
          
          // Logo on top-right like other screens
          Positioned(
            top: 60,
            right: 35,
            child: SafeArea(
              child: Image.asset(
                'assets/images/logoo.png',
                height: size.height * 0.15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Size size, String message, String timestamp) {
  return Semantics(
    label: 'Notification: $message',
    child: Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.00,
        vertical: size.height * 0.008,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Color(0xFFEBD2B0),
            Color.fromARGB(255, 233, 212, 182),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left white rounded box (like the small square in visual)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 14),

          // Message text
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Itim',
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3E3E3E),
                height: 1.3,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Timestamp
          Text(
            timestamp,
            style: const TextStyle(
              fontFamily: 'Itim',
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

}