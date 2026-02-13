import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'models/item.dart';

enum RecurringFilter { all, recurringOnly, oneTimeOnly }

class AppState extends ChangeNotifier {
  AppState._internal();
  static final AppState _instance = AppState._internal();
  static AppState get instance => _instance;

  static const currencies = {
    'EUR': '€',
    'USD': '\$',
    'GBP': '£',
    'CHF': 'Fr.',
  };

  final List<Item> _expenses = [];
  final List<Item> _incomes = [];

  late final Box<Item> _expensesBox;
  late final Box<Item> _incomesBox;
  late final Box _settingsBox;

  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  bool _showTags = true;
  String _currencyCode = 'EUR';
  RecurringFilter _recurringFilter = RecurringFilter.all;
  Set<String> _selectedTagFilters = {};

  /// Initialize AppState by loading persisted data.
  /// Must be called once before using AppState.
  Future<void> init() async {
    _expensesBox = Hive.box<Item>('expenses');
    _incomesBox = Hive.box<Item>('incomes');
    _settingsBox = Hive.box('settings');

    _currencyCode = _settingsBox.get('currency', defaultValue: 'EUR');

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
        date: DateTime.now(),
      );
      _incomes.add(salary);
      _incomesBox.put(salary.id, salary);
    }

    notifyListeners();
  }

  // Filtered by selected month + active filters
  List<Item> get expenses =>
      List.unmodifiable(_expenses
          .where(_shouldIncludeInMonth)
          .where(_matchesFilters)
          .toList());

  List<Item> get incomes =>
      List.unmodifiable(_incomes
          .where(_shouldIncludeInMonth)
          .where(_matchesFilters)
          .toList());

  // Unfiltered access (for tag operations)
  List<Item> get allExpenses => List.unmodifiable(_expenses);
  List<Item> get allIncomes => List.unmodifiable(_incomes);

  bool _matchesFilters(Item item) {
    if (_recurringFilter == RecurringFilter.recurringOnly && !item.isRecurring) return false;
    if (_recurringFilter == RecurringFilter.oneTimeOnly && item.isRecurring) return false;

    if (_selectedTagFilters.isNotEmpty &&
        !item.tags.any((t) => _selectedTagFilters.contains(t))) return false;

    return true;
  }

  bool _shouldIncludeInMonth(Item item) {
    if (item.date == null) return false;

    final itemMonth = DateTime(item.date!.year, item.date!.month);
    final selected = DateTime(_selectedMonth.year, _selectedMonth.month);

    if (item.isRecurring) {
      // Recurring: show from start date onward
      return !itemMonth.isAfter(selected);
    } else {
      // One-time: exact month match
      return itemMonth == selected;
    }
  }

  // Derived (uses filtered lists)
  double get totalExpenses =>
      expenses.fold(0.0, (sum, item) => sum + item.amount);

  double get totalIncomes =>
      incomes.fold(0.0, (sum, item) => sum + item.amount);

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

  // Show tags toggle

  bool get showTags => _showTags;

  void toggleShowTags() {
    _showTags = !_showTags;
    notifyListeners();
  }

  // Currency

  String get currencyCode => _currencyCode;
  String get currencySymbol => currencies[_currencyCode] ?? '€';

  void setCurrency(String code) {
    _currencyCode = code;
    _settingsBox.put('currency', code);
    notifyListeners();
  }

  // Filters

  RecurringFilter get recurringFilter => _recurringFilter;
  Set<String> get selectedTagFilters => Set.unmodifiable(_selectedTagFilters);

  bool get hasActiveFilters =>
      _recurringFilter != RecurringFilter.all || _selectedTagFilters.isNotEmpty;

  void setRecurringFilter(RecurringFilter filter) {
    _recurringFilter = filter;
    notifyListeners();
  }

  void toggleTagFilter(String tag) {
    if (_selectedTagFilters.contains(tag)) {
      _selectedTagFilters.remove(tag);
    } else {
      _selectedTagFilters.add(tag);
    }
    notifyListeners();
  }

  void clearFilters() {
    _recurringFilter = RecurringFilter.all;
    _selectedTagFilters = {};
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
