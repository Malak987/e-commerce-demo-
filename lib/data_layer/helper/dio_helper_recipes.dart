import 'package:dio/dio.dart';
import 'package:e_commerce_prof/styles/string.dart';

class DioHelperRecipes {
  static late Dio dio;
  static String? token;

  static void init() {

      dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          receiveDataWhenStatusError: true,
          headers: {'Content-Type': 'application/json',
           },
        ),
      );
    }

  static void setToken(String newToken) {
    token = newToken;
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
  static Future<Response> getDataRecipes({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    if (dio == null) init();
    return await dio!.get(url, queryParameters: query);
  }

  static Future<Response> postDataRecipes({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    if (dio == null) init();
    print(dio!.options.baseUrl + url);
    print(data);
    return await dio!.post(url, data: data);
  }

  static Future<Response> DeleteDataRecipes({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    if (dio == null) init();
    return await dio!.delete(url, data: data);
  }
}