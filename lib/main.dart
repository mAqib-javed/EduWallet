import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/notification_service.dart';
import 'providers/expense_provider.dart';
import 'providers/balance_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signUp_screen.dart';
import 'screens/HomePage_screen.dart';
import 'screens/spent_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/add_expenses_screen.dart';
import 'screens/financial_education_screen.dart';

void main() async {
  print('🔵 [MAIN] Starting app initialization...');
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('🔵 [MAIN] Initializing Firebase...');
    await Firebase.initializeApp();
    print('✅ [MAIN] Firebase initialized successfully');
  } catch (e) {
    print('❌ [MAIN] Firebase initialization error: $e');
  }
  
  try {
    print('🔵 [MAIN] Initializing notifications...');
    await NotificationService.initialize();
    await NotificationService.requestPermissions();
    print('✅ [MAIN] Notifications initialized successfully');
  } catch (e) {
    print('❌ [MAIN] Notification initialization error: $e');
  }
  
  print('🔵 [MAIN] Setting screen orientation...');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  print('🔵 [MAIN] Starting Flutter app...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider(create: (context) => BalanceProvider()),
      ],
      child: MaterialApp(
        title: 'EduWallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch: Colors.amber,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/home': (context) => const HomePageScreen(),
          '/spent': (context) => const SpentScreen(),
          '/notifications': (context) => const NotificationScreen(),
          '/add-expense': (context) => const AddExpensesScreen(),
          '/education': (context) => const FinancialEducationScreen(),
        },
      ),
    );
  }
}
