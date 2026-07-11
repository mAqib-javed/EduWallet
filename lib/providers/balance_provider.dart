import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/notification_service.dart';

class BalanceProvider extends ChangeNotifier {
  double _balance = 40.0;
  double _allowance = 255.0;
  List<Map<String, dynamic>> _expenses = [];

  double get balance => _balance;
  double get allowance => _allowance;
  List<Map<String, dynamic>> get expenses => _expenses;
  
  double get spentAmount => _allowance - _balance;
  double get progress => _balance / _allowance;

  BalanceProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _balance = prefs.getDouble('balance') ?? 40.0;
    _allowance = prefs.getDouble('allowance') ?? 255.0;
    
    final String? expensesJson = prefs.getString('expenses');
    if (expensesJson != null) {
      _expenses = List<Map<String, dynamic>>.from(json.decode(expensesJson));
      _calculateBalanceFromExpenses();
    }
    notifyListeners();
  }

  void _calculateBalanceFromExpenses() {
    double totalExpenses = 0.0;
    for (var expense in _expenses) {
      totalExpenses += expense['amount'].toDouble();
    }
    _balance = _allowance - totalExpenses;
  }

  Future<void> addExpense(double amount, [String category = 'General']) async {
    _balance -= amount;
    await _saveData();
    
    // Show expense notification
    await NotificationService.showExpenseNotification(category, amount, _balance);
    
    // Check for low balance and show notification if needed
    await _checkLowBalance();
    
    notifyListeners();
  }

  Future<void> updateBalance(double newBalance) async {
    double difference = newBalance - _balance;
    _balance = newBalance;
    await _saveData();
    
    // Show balance update notification
    if (difference != 0) {
      String action = difference > 0 ? 'added' : 'deducted';
      await NotificationService.showBalanceUpdateNotification(
        action, 
        difference.abs(), 
        _balance
      );
    }
    
    // Check for low balance
    await _checkLowBalance();
    
    notifyListeners();
  }

  Future<void> updateAllowance(double newAllowance) async {
    _allowance = newAllowance;
    await _saveData();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('balance', _balance);
    await prefs.setDouble('allowance', _allowance);
  }

  Future<void> refreshFromExpenses() async {
    await _loadData();
    await _checkLowBalance();
  }

  Future<void> _checkLowBalance() async {
    if (_allowance > 0) {
      double percentage = (_balance / _allowance) * 100;
      if (percentage <= 20 && percentage > 0) {
        await NotificationService.showLowBalanceNotification(_balance, _allowance);
      }
    }
  }
}