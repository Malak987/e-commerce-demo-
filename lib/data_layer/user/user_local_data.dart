import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';

class UserLocalData {

  // ════════════════════════════════════════
  //  TOKEN  →  SharedPreferences
  //  (آمن كفاية للـ token في معظم التطبيقات)
  // ════════════════════════════════════════

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  // ════════════════════════════════════════
  //  USER INFO  →  SharedPreferences
  // ════════════════════════════════════════

  Future<void> saveUserInfo(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', user.id ?? 0);
    await prefs.setString('username', user.username ?? '');
    await prefs.setString('email', user.email ?? '');
    await prefs.setString('first_name', user.firstName ?? '');
    await prefs.setString('last_name', user.lastName ?? '');
    await prefs.setString('gender', user.gender ?? '');
    await prefs.setString('image', user.image ?? '');
  }

  Future<User?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    if (id == null || id == 0) return null;
    return User(
      id: id,
      username: prefs.getString('username'),
      email: prefs.getString('email'),
      firstName: prefs.getString('first_name'),
      lastName: prefs.getString('last_name'),
      gender: prefs.getString('gender'),
      image: prefs.getString('image'),
    );
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_id');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('first_name');
    await prefs.remove('last_name');
    await prefs.remove('gender');
    await prefs.remove('image');
  }
}