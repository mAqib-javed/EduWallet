import 'package:flutter/material.dart';

class FinancialEducationScreen extends StatelessWidget {
  const FinancialEducationScreen({super.key});

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
                colors: [Color(0xFFF3E2B3), Color(0xFFE6C48F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header with title only
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.02,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Financial Education',
                          style: TextStyle(
                            fontFamily: 'Irish Grover',
                            fontSize: size.width * 0.067,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.008),
                        Container(
                          width: size.width * 0.45,
                          height: 1,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Column(
                      children: [
                        // Three informative cards with animations
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TweenAnimationBuilder(
                                duration: Duration(milliseconds: 600),
                                tween: Tween<double>(begin: 0, end: 1),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 50 * (1 - value)),
                                    child: Opacity(
                                      opacity: value,
                                      child: _buildInfoCard(
                                        size,
                                        'assets/icons/dollarskiptli.png',
                                        'Get Started Saving',
                                        [
                                          '• Create a monthly budget',
                                          '• Save at least 20% of income',
                                          '• Avoid unnecessary debt'
                                        ],
                                        'https://youtu.be/7ZfxVv4FC5o?si=nT_GSQRTTRY-Pqdb',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 18),
                              TweenAnimationBuilder(
                                duration: Duration(milliseconds: 800),
                                tween: Tween<double>(begin: 0, end: 1),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 50 * (1 - value)),
                                    child: Opacity(
                                      opacity: value,
                                      child: _buildInfoCard(
                                        size,
                                        'assets/icons/cash.png',
                                        'Manage Money Like the 1%',
                                        [
                                          '• Focus on investments',
                                          '• Control small expenses',
                                          '• Build passive income'
                                        ],
                                        'https://youtu.be/QThz1B8SHmc?si=ME7XUannFmpzDzai',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 18),
                              TweenAnimationBuilder(
                                duration: Duration(milliseconds: 1000),
                                tween: Tween<double>(begin: 0, end: 1),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 50 * (1 - value)),
                                    child: Opacity(
                                      opacity: value,
                                      child: _buildInfoCard(
                                        size,
                                        'assets/icons/edu.png',
                                        'Earn \$10,000 as a Student',
                                        [
                                          '• Freelance online',
                                          '• Sell digital products',
                                          '• Leverage social media'
                                        ],
                                        'https://youtu.be/5rhHm6WWOlS?si=JEIIfCDXzYmF5fu',
                                      ),
                                    ),
                                  );
                                },
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
                                Navigator.pushNamed(context, '/notifications');
                              },
                              icon: Image.asset(
                                'assets/icons/Bell.png',
                                width: 32,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.notifications, size: 32, color: Colors.black);
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
                          ],
                        ),
                        
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
                ),
              ],
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

  Widget _buildInfoCard(
    Size size,
    String iconPath,
    String title,
    List<String> bullets,
    String link,
  ) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFEBD2B0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon on the left
          Image.asset(
            iconPath,
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.info, size: 40, color: Colors.grey);
            },
          ),
          SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Irish Grover',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                // Bullet points
                ...bullets.map((bullet) => Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    bullet,
                    style: TextStyle(
                      fontFamily: 'Itim',
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                )).toList(),
                SizedBox(height: 8),
                // Clickable link
                GestureDetector(
                  onTap: () {
                    // Handle link tap - you can add URL launcher here
                    print('Opening: $link');
                  },
                  child: Text(
                    'Get more info on this link',
                    style: TextStyle(
                      fontFamily: 'Itim',
                      fontSize: 14,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}