import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'models/item.dart';

class AppState extends ChangeNotifier {
  AppState._internal();
  static final AppState _instance = AppState._internal();
  static AppState get instance => _instance;

  final List<Item> _expenses = [];
  final List<Item> _incomes = [];

  late final Box<Item> _expensesBox;
  late final Box<Item> _incomesBox;

  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  /// Initialize AppState by loading persisted data.
  /// Must be called once before using AppState.
  Future<void> init() async {
    _expensesBox = Hive.box<Item>('expenses');
    _incomesBox = Hive.box<Item>('incomes');

    _expenses.addAll(_expensesBox.values);
    _incomes.addAll(_incomesBox.values);

    // Seed example income only on first run (both boxes empty)
    if (_expenses.isEmpty && _incomes.isEmpty) {
      final salary = Item(
        id: 'inc1',
        title: 'Salary',
        amount: 1800,
        isRecurring: true,
        tags: ['Work'],
      );
      _incomes.add(salary);
      _incomesBox.put(salary.id, salary);
    }

    notifyListeners();
  }

  List<Item> get expenses =>
      List.unmodifiable(_expenses);

  List<Item> get incomes =>
      List.unmodifiable(_incomes);

  // Derived
  double get totalExpenses =>
      _expenses.fold(0.0, (sum, item) => sum + item.amount);

  double get totalIncomes =>
      _incomes.fold(0.0, (sum, item) => sum + item.amount);

  double get balance =>
      totalIncomes - totalExpenses;

  // Month selection

  DateTime get selectedMonth => _selectedMonth;

  void setSelectedMonth(DateTime month) {
    _selectedMonth = DateTime(month.year, month.month);
    notifyListeners();
  }

  void goToPreviousMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    notifyListeners();
  }

  void goToNextMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    notifyListeners();
  }

  /// All unique tags from both expenses and incomes
  Set<String> get allTags {
    final tags = <String>{};
    for (final item in _expenses) {
      tags.addAll(item.tags);
    }
    for (final item in _incomes) {
      tags.addAll(item.tags);
    }
    return tags;
  }

  // CRUD operations

  void addExpense(Item item) {
    _expenses.add(item);
    _expensesBox.put(item.id, item);
    notifyListeners();
  }

  void addIncome(Item item) {
    _incomes.add(item);
    _incomesBox.put(item.id, item);
    notifyListeners();
  }

  void updateExpense(Item updated) {
    final index = _expenses.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;

    _expenses[index] = updated;
    _expensesBox.put(updated.id, updated);
    notifyListeners();
  }

  void updateIncome(Item updated) {
    final index = _incomes.indexWhere((e) => e.id == updated.id);
    if (index == -1) return;

    _incomes[index] = updated;
    _incomesBox.put(updated.id, updated);
    notifyListeners();
  }

  void removeExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    _expensesBox.delete(id);
    notifyListeners();
  }

  void removeIncome(String id) {
    _incomes.removeWhere((e) => e.id == id);
    _incomesBox.delete(id);
    notifyListeners();
  }

  // Tag operations

  /// Rename a tag across all items
  void renameTag(String oldName, String newName) {
    if (oldName == newName) return;

    for (int i = 0; i < _expenses.length; i++) {
      if (_expenses[i].tags.contains(oldName)) {
        final updated = Item(
          id: _expenses[i].id,
          title: _expenses[i].title,
          amount: _expenses[i].amount,
          isRecurring: _expenses[i].isRecurring,
          tags: _expenses[i].tags.map((t) => t == oldName ? newName : t).toList(),
        );
        _expenses[i] = updated;
        _expensesBox.put(updated.id, updated);
      }
    }

    for (int i = 0; i < _incomes.length; i++) {
      if (_incomes[i].tags.contains(oldName)) {
        final updated = Item(
          id: _incomes[i].id,
          title: _incomes[i].title,
          amount: _incomes[i].amount,
          isRecurring: _incomes[i].isRecurring,
          tags: _incomes[i].tags.map((t) => t == oldName ? newName : t).toList(),
        );
        _incomes[i] = updated;
        _incomesBox.put(updated.id, updated);
      }
    }

    notifyListeners();
  }

  /// Delete a tag from all items (items remain, just lose the tag)
  void deleteTag(String tagName) {
    for (int i = 0; i < _expenses.length; i++) {
      if (_expenses[i].tags.contains(tagName)) {
        final updated = Item(
          id: _expenses[i].id,
          title: _expenses[i].title,
          amount: _expenses[i].amount,
          isRecurring: _expenses[i].isRecurring,
          tags: _expenses[i].tags.where((t) => t != tagName).toList(),
        );
        _expenses[i] = updated;
        _expensesBox.put(updated.id, updated);
      }
    }

    for (int i = 0; i < _incomes.length; i++) {
      if (_incomes[i].tags.contains(tagName)) {
        final updated = Item(
          id: _incomes[i].id,
          title: _incomes[i].title,
          amount: _incomes[i].amount,
          isRecurring: _incomes[i].isRecurring,
          tags: _incomes[i].tags.where((t) => t != tagName).toList(),
        );
        _incomes[i] = updated;
        _incomesBox.put(updated.id, updated);
      }
    }

    notifyListeners();
  }
}
