import 'package:hive/hive.dart';
import 'products.dart';

class ProductsAdapter extends TypeAdapter<Products> {
  @override
  final int typeId = 1;

  @override
  Products read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Products(
      id: fields[0] as int?,
      title: fields[1] as String?,
      description: fields[2] as String?,
      category: fields[3] as String?,
      price: fields[4] as double?,
      discountPercentage: fields[5] as double?,
      rating: fields[6] as double?,
      stock: fields[7] as int?,
      brand: fields[8] as String?,
      thumbnail: fields[9] as String?,
      images: (fields[10] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Products obj) {
    writer.writeByte(11); // عدد الـ fields
    writer.writeByte(0); writer.write(obj.id);
    writer.writeByte(1); writer.write(obj.title);
    writer.writeByte(2); writer.write(obj.description);
    writer.writeByte(3); writer.write(obj.category);
    writer.writeByte(4); writer.write(obj.price);
    writer.writeByte(5); writer.write(obj.discountPercentage);
    writer.writeByte(6); writer.write(obj.rating);
    writer.writeByte(7); writer.write(obj.stock);
    writer.writeByte(8); writer.write(obj.brand);
    writer.writeByte(9); writer.write(obj.thumbnail);
    writer.writeByte(10); writer.write(obj.images);
  }
}