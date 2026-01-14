/// Simple immutable model for a monthly item
/// (expense or income).
class Item {
  final String id;
  final String title;
  final double amount;
  final bool isRecurring;

  const Item({
    required this.id,
    required this.title,
    required this.amount,
    this.isRecurring = false,
  });
}
