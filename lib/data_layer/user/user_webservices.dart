import 'package:dio/dio.dart';
import 'package:e_commerce_prof/data_layer/user/user.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../styles/string.dart';
part 'user_webservices.g.dart';
@RestApi(baseUrl:baseUrl)
abstract class UserWebservices {
  factory UserWebservices(Dio dio, {String? baseUrl}) = _UserWebservices;
  @POST("auth/login")
  Future<User> login(@Body() Map<String, dynamic> data);
  @GET("auth/me")
  Future<User> getUser();
}


