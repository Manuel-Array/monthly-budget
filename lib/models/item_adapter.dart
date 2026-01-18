import 'package:hive/hive.dart';
import 'item.dart';

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 0;

  @override
  Item read(BinaryReader reader) {
    return Item(
      id: reader.readString(),
      title: reader.readString(),
      amount: reader.readDouble(),
      isRecurring: reader.readBool(),
      tags: reader.readStringList(),
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeDouble(obj.amount);
    writer.writeBool(obj.isRecurring);
    writer.writeStringList(obj.tags);
  }
}
