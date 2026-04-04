// lib/data_layer/user/user_repository.dart

import 'package:e_commerce_prof/data_layer/user/user_local_data.dart';
import 'package:e_commerce_prof/data_layer/user/user_webservices.dart';
import 'user.dart';

class UserRepository {
  final UserWebservices userWebservices;
  final UserLocalData _localData = UserLocalData();

  UserRepository(this.userWebservices);

  // ════════════════════════════════════════
  //  LOGIN
  // ════════════════════════════════════════

  Future<User> login({
    required String username,
    required String password,
  }) async {
    // 1. طلب من API
    final user = await userWebservices.login({
      "username": username,
      "password": password,
    });

    // 2. حفظ التوكن في flutter_secure_storage
    if (user.accessToken != null) {
      await _localData.saveToken(user.accessToken!);
    }

    // 3. حفظ بيانات اليوزر في SharedPreferences
    await _localData.saveUserInfo(user);

    return user;
  }

  // ════════════════════════════════════════
  //  GET USER
  //  أول بيجرب من API، لو فشل يرجع المحفوظ
  // ════════════════════════════════════════

  Future<User> getUser() async {
    try {
      final user = await userWebservices.getUser();
      // نحدث البيانات المحفوظة
      await _localData.saveUserInfo(user);
      return user;
    } catch (e) {
      // لو API فشل → نرجع اللي محفوظ محلياً
      final savedUser = await _localData.getUserInfo();
      if (savedUser != null) return savedUser;
      rethrow;
    }
  }

  // ════════════════════════════════════════
  //  TOKEN
  // ════════════════════════════════════════

  Future<String?> getToken() => _localData.getToken();

  Future<bool> isLoggedIn() => _localData.isLoggedIn();

  // ════════════════════════════════════════
  //  LOGOUT
  // ════════════════════════════════════════

  Future<void> logout() async {
    await _localData.clearAll();
  }
  Future<User?> getSavedUser() async {
    return await _localData.getUserInfo();
  }
}