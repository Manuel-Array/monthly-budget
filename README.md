# Monthly Budget

A simple personal finance app built with **Flutter** to track monthly incomes and expenses and quickly see your balance.

---

## Features

* Add monthly expenses and incomes
* Mark items as recurring (monthly) or one-time
* Tag items for categorization (e.g. "Home", "Work", "Subscriptions")
* Month selection with automatic filtering
* Automatic calculation of totals and balance per month
* Swipe to delete items
* Edit existing items
* Local persistence (data survives app restarts)
* Currency selection (EUR, USD, GBP, CHF)
* Toggle to show/hide tags on item cards
* Settings with tag management (rename/delete tags)

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
context.read<AppState>().addExpense(item);
```

---

## Coding Conventions

### Naming

* Files: `snake_case.dart`
* Classes: `PascalCase`
* Variables & methods: `camelCase`
* Widgets:
  * Pages → `SomethingPage`
  * Reusable widgets → descriptive nouns (`BalanceCard`, `ItemList`)

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

* Filter by tags or recurring status
* Statistics and reports
