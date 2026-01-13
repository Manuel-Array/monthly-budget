import 'package:flutter/foundation.dart';
import 'models/fixed_item.dart';

class AppState extends ChangeNotifier {
  AppState._internal();
  static final AppState _instance = AppState._internal();
  static AppState get instance => _instance;

  // Fixed monthly data
  final List<FixedItem> _fixedExpenses = [];
  final List<FixedItem> _fixedIncomes = [];

  List<FixedItem> get fixedExpenses =>
      List.unmodifiable(_fixedExpenses);

  List<FixedItem> get fixedIncomes =>
      List.unmodifiable(_fixedIncomes);

  // Derived values
  double get totalFixedExpenses =>
      _fixedExpenses.fold(0.0, (sum, item) => sum + item.amount);

  double get totalFixedIncomes =>
      _fixedIncomes.fold(0.0, (sum, item) => sum + item.amount);

  double get moneyLeft =>
      totalFixedIncomes - totalFixedExpenses;

  // Mutations
  void addFixedExpense(FixedItem item) {
    _fixedExpenses.add(item);
    notifyListeners();
  }

  void addFixedIncome(FixedItem item) {
    _fixedIncomes.add(item);
    notifyListeners();
  }

  void updateFixedExpense(FixedItem updated) {
    final index = _fixedExpenses.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;

    _fixedExpenses[index] = updated;
    notifyListeners();
  }

  void updateFixedIncome(FixedItem updated) {
    final index = _fixedIncomes.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;

    _fixedIncomes[index] = updated;
    notifyListeners();
  }

  void removeFixedExpense(String id) {
    _fixedExpenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void removeFixedIncome(String id) {
    _fixedIncomes.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // Dev-only helper to avoid empty UI at startup
  void seedDemoDataIfEmpty() {
    if (_fixedExpenses.isNotEmpty || _fixedIncomes.isNotEmpty) return;

    _fixedIncomes.add(
      FixedItem(id: 'inc1', title: 'Salary', amount: 1800),
    );

    _fixedExpenses.addAll([
      FixedItem(id: 'exp1', title: 'Rent', amount: 650),
      FixedItem(id: 'exp2', title: 'Internet', amount: 29.99),
    ]);

    notifyListeners();
  }
}
