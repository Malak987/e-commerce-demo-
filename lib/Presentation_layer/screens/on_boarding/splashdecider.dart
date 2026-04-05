import 'package:e_commerce_prof/Business_logic_layer/user/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    _decide();
  }

  Future<void> _decide() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final seenOnBoarding = prefs.getBool('seen_onboarding') ?? false;
      final localData = UserLocalData();
      final token = await localData.getToken();
      final isLoggedIn = token != null && token.isNotEmpty;

      // ← احذف fetchUser من هنا خالص، MainLayout هيعملها

      FlutterNativeSplash.remove();

      if (!mounted) return;

      if (!seenOnBoarding) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
        );
      } else if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
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
      body: SizedBox.shrink(), // ← مش بنعرض حاجة، الـ splash screen كافية
    );
  }
}