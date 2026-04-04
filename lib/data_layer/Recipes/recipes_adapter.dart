import 'package:hive/hive.dart';
import 'recipes.dart';

class RecipesAdapter extends TypeAdapter<Recipes> {
  @override
  final int typeId = 2;

  @override
  Recipes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipes(
      id: fields[0] as int?,
      name: fields[1] as String?,
      image: fields[2] as String?,
      cuisine: fields[3] as String?,
      difficulty: fields[4] as String?,
      prepTimeMinutes: fields[5] as int?,
      cookTimeMinutes: fields[6] as int?,
      servings: fields[7] as int?,
      caloriesPerServing: fields[8] as int?,
      rating: fields[9] as double?,
      reviewCount: fields[10] as int?,
      userId: fields[11] as int?,
      ingredients: (fields[12] as List?)?.cast<String>(),
      instructions: (fields[13] as List?)?.cast<String>(),
      tags: (fields[14] as List?)?.cast<String>(),
      mealType: (fields[15] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Recipes obj) {
    writer.writeByte(16); // عدد الـ fields
    writer.writeByte(0);  writer.write(obj.id);
    writer.writeByte(1);  writer.write(obj.name);
    writer.writeByte(2);  writer.write(obj.image);
    writer.writeByte(3);  writer.write(obj.cuisine);
    writer.writeByte(4);  writer.write(obj.difficulty);
    writer.writeByte(5);  writer.write(obj.prepTimeMinutes);
    writer.writeByte(6);  writer.write(obj.cookTimeMinutes);
    writer.writeByte(7);  writer.write(obj.servings);
    writer.writeByte(8);  writer.write(obj.caloriesPerServing);
    writer.writeByte(9);  writer.write(obj.rating);
    writer.writeByte(10); writer.write(obj.reviewCount);
    writer.writeByte(11); writer.write(obj.userId);
    writer.writeByte(12); writer.write(obj.ingredients);
    writer.writeByte(13); writer.write(obj.instructions);
    writer.writeByte(14); writer.write(obj.tags);
    writer.writeByte(15); writer.write(obj.mealType);
  }
}