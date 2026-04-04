import 'package:e_commerce_prof/data_layer/user/user.dart';
import 'package:hive/hive.dart';

class UserAdapter extends TypeAdapter<User>{
  @override
  final int typeId = 0;
  @override
  User read(BinaryReader reader){
    return User(
      accessToken: reader.read(),
      refreshToken: reader.read(),
      id: reader.read(),
      email: reader.read(),
      username: reader.read(),
      firstName: reader.read(),
      lastName: reader.read(),
      gender: reader.read(),
      image: reader.read(),
    );
  }
  @override
  void write(BinaryWriter writer, User obj){
    writer.write(obj.accessToken);
    writer.write(obj.refreshToken);
    writer.write(obj.id);
    writer.write(obj.email);
    writer.write(obj.username);
    writer.write(obj.firstName);
    writer.write(obj.lastName);
    writer.write(obj.gender);
    writer.write(obj.image);
  }
}