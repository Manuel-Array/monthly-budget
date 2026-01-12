/// Simple immutable model for a fixed monthly item
/// (expense or income).
class FixedItem {
  final String id;
  final String title;
  final double amount;

  const FixedItem({
    required this.id,
    required this.title,
    required this.amount,
  });
}