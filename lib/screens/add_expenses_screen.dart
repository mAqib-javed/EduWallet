// Replace CustomDisplayFont with your actual font family name from assets/fonts/
// Replace icon asset names: rectangle.png, pump.png, drink.png, spoons.png with actual names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/balance_provider.dart';
import 'dart:convert';

class AddExpensesScreen extends StatefulWidget {
  const AddExpensesScreen({super.key});

  @override
  State<AddExpensesScreen> createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  final _nameController = TextEditingController();
  final _costsController = TextEditingController();
  int _selectedIconIndex = 0;

  final List<Map<String, String>> _icons = [
    {'name': 'Food', 'asset': 'assets/icons/spoons.png'},
    {'name': 'Fuel', 'asset': 'assets/icons/pump.png'},
    {'name': 'Drinks', 'asset': 'assets/icons/drink.png'},
    {'name': 'Others', 'asset': 'assets/icons/Rectangle.png'},
  ];

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Fuel':
        return Icons.local_gas_station;
      case 'Drinks':
        return Icons.local_drink;
      case 'Others':
      default:
        return Icons.category;
    }
  }

  Future<void> _saveExpense() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing expenses
    final String? expensesJson = prefs.getString('expenses');
    List<Map<String, dynamic>> expenses = [];
    
    if (expensesJson != null) {
      expenses = List<Map<String, dynamic>>.from(json.decode(expensesJson));
    }
    
    // Add new expense
    final newExpense = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': _nameController.text.trim(),
      'amount': double.parse(_costsController.text),
      'category': _icons[_selectedIconIndex]['name']!,
      'iconPath': _icons[_selectedIconIndex]['asset']!,
      'date': DateTime.now().toIso8601String(),
    };
    
    expenses.add(newExpense);
    
    // Save back to SharedPreferences
    await prefs.setString('expenses', json.encode(expenses));
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
                    
                    // Back button and Add Expenses title in same row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'back',
                            style: TextStyle(
                              fontFamily: 'Irish Grover',
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'Add Expenses',
                              style: TextStyle(
                                fontFamily: 'Irish Grover',
                                fontSize: size.width * 0.067,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: size.height * 0.008),
                            Container(
                              width: size.width * 0.5,
                              height: 1.8,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        SizedBox(width: size.width * 0.12), // Space for logo
                      ],
                    ),
                    
                    SizedBox(height: size.height * 0.20),

                  // Name input field with animation
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 400),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(-30 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name',
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: size.height * 0.025),
                  
                  // Costs input field with animation
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 600),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(-30 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Costs',
                                style: TextStyle(
                                  fontFamily: 'Ink Free',
                                  fontSize: size.width * 0.063,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              TextField(
                                controller: _costsController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade300,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixText: '\$ ',
                                  prefixStyle: TextStyle(
                                    color: Colors.black87,
                                    fontSize: size.width * 0.04,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: size.height * 0.035),
                  
                  // Icon selector grid
                  SizedBox(
                    height: size.height * 0.2,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: size.width * 0.03,
                        mainAxisSpacing: size.height * 0.015,
                        childAspectRatio: 2.2,
                      ),
                      itemCount: _icons.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedIconIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIconIndex = index;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02,
                              vertical: size.height * 0.008,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.black87 : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: size.width * 0.06,
                                  height: size.width * 0.06,
                                  child: Image.asset(
                                    _icons[index]['asset']!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        _getIconForCategory(_icons[index]['name']!),
                                        size: size.width * 0.06,
                                        color: isSelected ? Colors.white : Colors.black87,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                Flexible(
                                  child: Text(
                                    _icons[index]['name']!,
                                    style: TextStyle(
                                      fontFamily: 'Irish Grover',
                                      fontSize: size.width * 0.032,
                                      color: isSelected ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  SizedBox(height: size.height * 0.04),
                  
                  // Submit button
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE6C48F), Color(0xFFF3E2B3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_nameController.text.isNotEmpty && _costsController.text.isNotEmpty) {
                            try {
                              double expenseAmount = double.parse(_costsController.text);
                              String category = _icons[_selectedIconIndex]['name']!;
                              await _saveExpense();
                              
                              // Update balance with category for notification
                              context.read<BalanceProvider>().addExpense(expenseAmount, category);
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Expense added successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error saving expense. Please try again.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill all fields')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.2,
                            vertical: size.height * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontFamily: 'Imbue',
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            ),
          ),
          
          // Logo on top-right like SignUp screen
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
}