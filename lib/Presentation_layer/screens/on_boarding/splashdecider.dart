import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data_layer/user/user_local_data.dart';
import '../login/login_screen.dart';
import '../mainLayout/MainLayout.dart';
import '../on_boarding/on_boarding_screen.dart';

class SplashDecider extends StatefulWidget {
  const SplashDecider({super.key});

  @override
  State<SplashDecider> createState() => _SplashDeciderState();
}

class _SplashDeciderState extends State<SplashDecider> {
  @override
  void initState() {
    super.initState();
    // ✅ ننادي بعد أول frame يتبني
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _decide();
    });
  }

  Future<void> _decide() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final seenOnBoarding = prefs.getBool('seen_onboarding') ?? false;
      final token = await UserLocalData().getToken();
      final isLoggedIn = token != null && token.isNotEmpty;

      if (!mounted) return;

      Widget nextScreen;

      if (!seenOnBoarding) {
        nextScreen = const OnBoardingScreen();
      } else if (isLoggedIn) {
        nextScreen = const MainLayout();
      } else {
        nextScreen = LoginScreen();
      }

      // ✅ أزيل الـ splash الأول ثم انتقل
      FlutterNativeSplash.remove();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    } catch (e) {
      FlutterNativeSplash.remove();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.shrink(),
    );
  }
}