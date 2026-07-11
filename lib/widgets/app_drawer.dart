import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/lgo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.05),
              
              // Logo
              Image.asset(
                'assets/images/logoo.png',
                height: size.height * 0.15,
              ),
              
              SizedBox(height: size.height * 0.05),
              
              // Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      context,
                      size,
                      'Home',
                      'assets/icons/home.png',
                      '/home',
                    ),
                    _buildDrawerItem(
                      context,
                      size,
                      'Spent',
                      'assets/icons/dollars.png',
                      '/spent',
                    ),
                    _buildDrawerItem(
                      context,
                      size,
                      'Notifications',
                      'assets/icons/Bell.png',
                      '/notifications',
                    ),
                    _buildDrawerItem(
                      context,
                      size,
                      'Education',
                      'assets/icons/book.png',
                      '/education',
                    ),
                    SizedBox(height: size.height * 0.02),
                    _buildLogoutItem(context, size),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    Size size,
    String title,
    String iconPath,
    String route,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      child: ListTile(
        leading: Image.asset(
          iconPath,
          width: size.width * 0.08,
          height: size.width * 0.08,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.circle,
              size: size.width * 0.08,
              color: Colors.black,
            );
          },
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Irish Grover',
            fontSize: size.width * 0.05,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, route);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.white.withOpacity(0.3),
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context, Size size) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.01,
      ),
      child: ListTile(
        leading: Icon(
          Icons.logout,
          size: size.width * 0.08,
          color: Colors.black,
        ),
        title: Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'Irish Grover',
            fontSize: size.width * 0.05,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.red.withOpacity(0.1),
      ),
    );
  }
}