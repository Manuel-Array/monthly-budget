/// Simple immutable model for a monthly item
/// (expense or income).
class FixedItem {
  final String id;
  final String title;
  final double amount;
  final bool isRecurring;

  const FixedItem({
    required this.id,
    required this.title,
    required this.amount,
    this.isRecurring = false,
  });
}