import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/balance_provider.dart';
import '../widgets/numeric_keypad_dialog.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void initState() {
    super.initState();
    print('✅ [HOME] HomePageScreen initState called - Navigation successful!');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🔵 [HOME] Refreshing balance from expenses...');
      context.read<BalanceProvider>().refreshFromExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const AppDrawer(),
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
                // AppBar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.01,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Builder(
                            builder: (context) => IconButton(
                              onPressed: () => Scaffold.of(context).openDrawer(),
                              icon: Icon(
                                Icons.menu,
                                color: Colors.black,
                                size: size.width * 0.07,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'HomePage',
                                style: TextStyle(
                                  fontFamily: 'Irish Grover',
                                  fontSize: size.width * 0.075,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.15),
                        ],
                      ),
                      Container(
                        width: size.width * 0.35,
                        height: 2,
                        color: Colors.black,
                        margin: EdgeInsets.only(top: size.height * 0.01),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Column(
                      children: [
                        // Balance & Allowance Section
                        Consumer<BalanceProvider>(
                          builder: (context, balanceProvider, child) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Balance',
                                        style: TextStyle(
                                          fontFamily: 'Ink Free',
                                          fontSize: size.width * 0.070,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '\$${balanceProvider.balance.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontFamily: "Irish Grover",
                                          fontSize: size.width * 0.10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.005),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.all(2),
                                            constraints: BoxConstraints(minWidth: 30, minHeight: 25),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => NumericKeypadDialog(
                                                  title: 'Add to Balance',
                                                  onNumberSelected: (value) {
                                                    balanceProvider.updateBalance(balanceProvider.balance + value);
                                                  },
                                                ),
                                              );
                                            },
                                            icon: Image.asset('assets/icons/plus.png', width: 25),
                                          ),
                                          SizedBox(width: 4),
                                          IconButton(
                                            padding: EdgeInsets.all(4),
                                            constraints: BoxConstraints(minWidth: 30, minHeight: 25),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => NumericKeypadDialog(
                                                  title: 'Subtract from Balance',
                                                  onNumberSelected: (value) {
                                                    balanceProvider.updateBalance(balanceProvider.balance - value);
                                                  },
                                                ),
                                              );
                                            },
                                            icon: Image.asset('assets/icons/minus.png', width: 25),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Allowance',
                                        style: TextStyle(
                                          fontFamily: 'Ink Free',
                                          fontSize: size.width * 0.070,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '\$${balanceProvider.allowance.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontFamily: "Irish Grover",
                                          fontSize: size.width * 0.10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.005),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.all(2),
                                            constraints: BoxConstraints(minWidth: 25, minHeight: 25),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => NumericKeypadDialog(
                                                  title: 'Add to Allowance',
                                                  onNumberSelected: (value) {
                                                    balanceProvider.updateAllowance(balanceProvider.allowance + value);
                                                  },
                                                ),
                                              );
                                            },
                                            icon: Image.asset('assets/icons/plus.png', width: 25),
                                          ),
                                          SizedBox(width: 4),
                                          IconButton(
                                            padding: EdgeInsets.all(4),
                                            constraints: BoxConstraints(minWidth: 30, minHeight: 25),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => NumericKeypadDialog(
                                                  title: 'Subtract from Allowance',
                                                  onNumberSelected: (value) {
                                                    balanceProvider.updateAllowance(balanceProvider.allowance - value);
                                                  },
                                                ),
                                              );
                                            },
                                            icon: Image.asset('assets/icons/minus.png', width: 25),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        
                        SizedBox(height: size.height * 0.04),
                        
                        // Dynamic Progress Bar
                        Consumer<BalanceProvider>(
                          builder: (context, balanceProvider, child) {
                            double progress = balanceProvider.progress.clamp(0.0, 1.0);
                            return Container(
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    // Red background (used portion)
                                    Container(
                                      width: double.infinity,
                                      height: 20,
                                      color: Colors.red,
                                    ),
                                    // Green foreground (remaining portion)
                                    FractionallySizedBox(
                                      widthFactor: progress,
                                      child: Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        
                        SizedBox(height: size.height * 0.05),
                        
                        // History Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'recent history',
                                style: TextStyle(
                                  fontFamily: 'Joti One',
                                  fontSize: size.width * 0.05,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: size.height * 0.025),
                              
                              // Income Section
                              Text(
                                'Income',
                                style: TextStyle(
                                  fontSize: size.width * 0.060,
                                  fontFamily: "Ink Free",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              
                              Text(
                                'Parents - \$20',
                                style: TextStyle(
                                  fontFamily: "Jockey One",
                                  fontSize: size.width * 0.05,
                                  color: Colors.black,
                                ),
                              ),
                              
                              SizedBox(height: size.height * 0.025),
                              
                              // Expenses Section
                              Text(
                                'Expenses',
                                style: TextStyle(
                                  fontFamily: "Ink Free",
                                  fontSize: size.width * 0.060,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                height: 2,
                                color: Colors.black,
                                margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
                              ),
                              Text(
                                'Food - \$65',
                                style: TextStyle(
                                  fontFamily: "Jockey One",
                                  fontSize: size.width * 0.05,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Icon Buttons at bottom
                        SizedBox(height: size.height * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/spent');
                              },
                              icon: Image.asset('assets/icons/dollars.png', width: 32),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/notifications');
                              },
                              icon: Image.asset('assets/icons/Bell.png', width: 32),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/education');
                              },
                              icon: Image.asset('assets/icons/book.png', width: 32),
                            ),
                          ],
                        ),
                      ],
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