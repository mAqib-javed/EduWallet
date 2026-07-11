import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
    _initialized = true;
  }

  static Future<void> requestPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showLowBalanceNotification(double balance, double allowance) async {
    double percentage = (balance / allowance) * 100;
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'balance_alerts',
      'Balance Alerts',
      channelDescription: 'Notifications for low balance warnings',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      1,
      '⚠️ Low Balance Alert',
      'Your balance is ${percentage.toStringAsFixed(1)}% (\$${balance.toStringAsFixed(2)}). Consider managing your expenses!',
      details,
    );
  }

  static Future<void> showExpenseNotification(String category, double amount, double remainingBalance) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'expense_alerts',
      'Expense Alerts',
      channelDescription: 'Notifications for expense tracking',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      2,
      '💸 Expense Added',
      '$category expense of \$${amount.toStringAsFixed(2)} added. Remaining balance: \$${remainingBalance.toStringAsFixed(2)}',
      details,
    );
  }

  static Future<void> showBalanceUpdateNotification(String action, double amount, double newBalance) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'balance_updates',
      'Balance Updates',
      channelDescription: 'Notifications for balance changes',
      importance: Importance.low,
      priority: Priority.low,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    String emoji = action == 'added' ? '💰' : '💳';
    
    await _notifications.show(
      3,
      '$emoji Balance Updated',
      '\$${amount.toStringAsFixed(2)} $action to balance. New balance: \$${newBalance.toStringAsFixed(2)}',
      details,
    );
  }
}