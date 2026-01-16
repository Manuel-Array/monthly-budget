/// Single budget entry (expense or income)
class Item {
  final String id;
  final String title;
  final double amount;
  final bool isRecurring;
  final List<String> tags;

  const Item({
    required this.id,
    required this.title,
    required this.amount,
    this.isRecurring = false,
    this.tags = const [],
  });
}
