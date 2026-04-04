// dio_helper.dart
import 'package:dio/dio.dart';
import 'package:e_commerce_prof/styles/string.dart';

class DioHelper_Products {
  static late Dio dio;
  static String? token;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // إضافة interceptor لإضافة التوكن تلقائياً
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // إضافة التوكن إذا كان موجوداً
          if (token != null && token!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // التعامل مع حالة 401 هنا
            print("401 Error: Token might be expired or invalid");
          }
          return handler.next(error);
        },
      ),
    );
  }

  static void setToken(String newToken) {
    token = newToken;
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static Future<Response> getData_products({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: headers);
      return await dio.get(
        url,
        queryParameters: query,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> postData_products({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: headers);
      return await dio.post(
        url,
        data: data,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }
}