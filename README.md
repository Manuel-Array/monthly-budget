# Monthly Budget

A simple personal finance app built with **Flutter** to keep track of fixed monthly incomes and expenses and quickly see how much money is left.

---

## Features (current)

* Add fixed monthly expenses
* Add fixed monthly incomes
* Automatic calculation of:
  * total fixed expenses
  * total fixed incomes
  * free money (incomes - expenses)
* Swipe to delete items

Note: Demo data is temporarily seeded at startup to make development and UI testing easier.

---

## Architecture Overview

* **Global App State**

  * Stored in a singleton `AppState`
  * Implemented using `ChangeNotifier`
  * Exposed via `provider`

* **Business Logic**

  * Lives inside `AppState`
  * UI never calculates totals directly

* **UI**

  * Pages are responsible for UI structure only
  * Reusable components live in `widgets/`
  * State is read using `context.watch<AppState>()`

---

## State Management Rules

* `AppState` is the single source of truth
* All mutations call `notifyListeners()`
* Widgets read state and trigger actions, but never contain business rules

Example:

```dart
context.read<AppState>().addFixedExpense(item);
```

---

## Coding Conventions

### Naming

* Files: `snake_case.dart`
* Classes: `PascalCase`
* Variables & methods: `camelCase`
* Widgets:
  * Pages → `SomethingPage`
  * Reusable widgets → descriptive nouns (`SummaryCards`, `FixedList`)

### State

* Global state → `AppState`
* UI-only state → `StatefulWidget`
* No logic inside `build()` other than layout decisions

### Models

* Immutable data classes
* No logic inside models
* Pure data containers

---

## Planned Features

* Persistent storage (SharedPreferences or local DB)
* Monthly reset logic
* Variable (non-recurring) expenses
* Editing existing items
* Categories & statistics
