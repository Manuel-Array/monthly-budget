import 'package:flutter/foundation.dart';
import 'models/item.dart';

class AppState extends ChangeNotifier {
  AppState._internal();
  static final AppState _instance = AppState._internal();
  static AppState get instance => _instance;

  final List<Item> _expenses = [];
  final List<Item> _incomes = [];

  List<Item> get expenses =>
      List.unmodifiable(_expenses);

  List<Item> get incomes =>
      List.unmodifiable(_incomes);

  // Derived
  double get totalExpenses =>
      _expenses.fold(0.0, (sum, item) => sum + item.amount);

  double get totalIncomes =>
      _incomes.fold(0.0, (sum, item) => sum + item.amount);

  double get moneyLeft =>
      totalIncomes - totalExpenses;

  // Updates
  void addExpense(Item item) {
    _expenses.add(item);
    notifyListeners();
  }

  void addIncome(Item item) {
    _incomes.add(item);
    notifyListeners();
  }

  void updateExpense(Item updated) {
    final index = _expenses.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;

    _expenses[index] = updated;
    notifyListeners();
  }

  void updateIncome(Item updated) {
    final index = _incomes.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;

    _incomes[index] = updated;
    notifyListeners();
  }

  void removeExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void removeIncome(String id) {
    _incomes.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // Dev-only helper to avoid empty UI at startup
  void seedDemoDataIfEmpty() {
    if (_expenses.isNotEmpty || _incomes.isNotEmpty) return;

    _incomes.add(
      Item(id: 'inc1', title: 'Salary', amount: 1800, isRecurring: true, tags: ['Work']),
    );

    _expenses.addAll([
      Item(id: 'exp1', title: 'Rent', amount: 650, isRecurring: true, tags: ['Home']),
      Item(id: 'exp2', title: 'Internet', amount: 29.99, isRecurring: true, tags: ['Home', 'Subscriptions']),
    ]);

    notifyListeners();
  }
}
