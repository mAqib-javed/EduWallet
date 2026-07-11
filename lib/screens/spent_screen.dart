import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add_expenses_screen.dart';

class SpentScreen extends StatefulWidget {
  const SpentScreen({super.key});

  @override
  State<SpentScreen> createState() => _SpentScreenState();
}

class _SpentScreenState extends State<SpentScreen> {
  List<Map<String, dynamic>> expenses = [];
  double totalAmount = 0.0;
  Map<String, double> categoryTotals = {
    'Food': 0.0,
    'Drinks': 0.0,
    'Fuel': 0.0,
    'Others': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expensesJson = prefs.getString('expenses');
    
    if (expensesJson != null) {
      final List<dynamic> expensesList = json.decode(expensesJson);
      setState(() {
        expenses = expensesList.cast<Map<String, dynamic>>();
        _calculateTotals();
      });
    }
  }

  void _calculateTotals() {
    totalAmount = 0.0;
    categoryTotals = {
      'Food': 0.0,
      'Drinks': 0.0,
      'Fuel': 0.0,
      'Others': 0.0,
    };
    
    for (var expense in expenses) {
      double amount = expense['amount'].toDouble();
      String category = expense['category'];
      
      totalAmount += amount;
      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] = categoryTotals[category]! + amount;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.09),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.005),
                    
                    // Spent title centered
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Spent',
                            style: TextStyle(
                              fontFamily: 'Irish Grover',
                              fontSize: size.width * 0.067,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: size.height * 0.008),
                          Container(
                            width: size.width * 0.2,
                            height: 1.5,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.17),
                    
                    // Total section with animation
                    TweenAnimationBuilder(
                      duration: Duration(milliseconds: 800),
                      tween: Tween<double>(begin: 0, end: totalAmount),
                      builder: (context, value, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontFamily: 'Ink Free',
                                fontSize: size.width * 0.075,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '\$${value.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: "Irish Grover",
                                fontSize: size.width * 0.12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    
                    SizedBox(height: size.height * 0.05),
                    
                    // Static expense rows
                    Column(
                      children: [
                        // Food row
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.15,
                                  child: Text(
                                    'Food',
                                    style: TextStyle(
                                      fontFamily: 'Imbue',
                                      fontSize: size.width * 0.06,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.05),
                                Image.asset(
                                  'assets/icons/spoons.png',
                                  width: size.width * 0.08,
                                  height: size.width * 0.08,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.restaurant,
                                      size: size.width * 0.08,
                                      color: Colors.black,
                                    );
                                  },
                                ),
                                SizedBox(width: size.width * 0.05),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.03,
                                    vertical: size.height * 0.005,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '\$${categoryTotals['Food']!.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontFamily: 'Imbue',
                                      fontSize: size.width * 0.05,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.01),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        
                        SizedBox(height: size.height * 0.02),
                        
                        // Drinks row
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.15,
                                  child: Text(
                                    'Drinks',
                                    style: TextStyle(
                                      fontFamily: 'Imbue',
                                      fontSize: size.width * 0.06,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.05),
                                Image.asset(
                                  'assets/icons/drink.png',
                                  width: size.width * 0.08,
                                  height: size.width * 0.08,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.local_drink,
                                      size: size.width * 0.08,
                                      color: Colors.black,
                                    );
                                  },
                                ),
                                SizedBox(width: size.width * 0.05),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.03,
                                    vertical: size.height * 0.005,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '\$${categoryTotals['Drinks']!.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontFamily: 'Imbue',
                                      fontSize: size.width * 0.05,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.01),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        
                        SizedBox(height: size.height * 0.02),
                        
                        // Fuel row
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.15,
                                  child: Text(
                                    'Fuel',
                                    style: TextStyle(
                                      fontFamily: 'Imbue',
                                      fontSize: size.width * 0.06,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.05),
                                Image.asset(
                                  'assets/icons/pump.png',
                                  width: size.width * 0.08,
                                  height: size.width * 0.08,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.local_gas_station,
                                      size: size.width * 0.08,
                                      color: Colors.black,
                                    );
                                  },
                                ),
                                SizedBox(width: size.width * 0.05),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.03,
                                    vertical: size.height * 0.005,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '\$${categoryTotals['Fuel']!.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontFamily: 'Imbue',
                                      fontSize: size.width * 0.05,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.01),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: size.height * 0.04),
                    
                    // Add Expense Button aligned left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddExpensesScreen()),
                          );
                          // Refresh expenses when returning from add screen
                          _loadExpenses();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.2,
                            vertical: size.height * 0.010,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/plus.png',
                              width: size.width * 0.05,
                              height: size.width * 0.05,
                              color: Colors.black,
                            ),
                            SizedBox(width: size.width * 0.02),
                            Text(
                              'Add Expense',
                              style: TextStyle(
                                fontFamily: 'Imbue',
                                color: Colors.black,
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Bottom navigation icons positioned like home screen
                    SizedBox(height: size.height * 0.12),
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.03),
                      child: Row(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Logo on top-right like Add Expenses screen
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

  Widget _buildContainerBox(Size size, String title, String iconPath) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: size.width * 0.08,
            height: size.width * 0.08,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.attach_money,
                size: size.width * 0.08,
                color: Colors.black,
              );
            },
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Ink Free',
                fontSize: size.width * 0.045,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}