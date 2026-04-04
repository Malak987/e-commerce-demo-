import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data_layer/helper/dio_helper.dart';
import '../../data_layer/user/user.dart';
import '../../data_layer/user/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserInitial());

  Future<void> loginUser({
    required String username,
    required String password,
  }) async {
    emit(UserLoading());
    try {
      final user = await userRepository.login(
        username: username,
        password: password,
      );

      // تعيين التوكن في DioHelper
      if (user.accessToken != null) {
        DioHelper_Products.setToken(user.accessToken!);
      }

      emit(UserSuccess(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> fetchUser() async {
    emit(UserLoading());
    try {
      // 1️⃣ أول حاجة: اعرض اللي محفوظ محلياً فوراً
      final savedUser = await userRepository.getSavedUser();
      if (savedUser != null) {
        emit(UserSuccess(savedUser)); // ← يظهر فوراً بدون انتظار
      }

      // 2️⃣ في الخلفية: حاول تحدّث من API
      final token = await userRepository.getToken();
      if (token != null) {
        DioHelper_Products.setToken(token);
      }

      final freshUser = await userRepository.getUser();
      emit(UserSuccess(freshUser)); // ← يحدّث لو نجح

    } catch (e) {
      // لو API فشل والمحلي موجود، ابقى على UserSuccess
      // لو مفيش حاجة محلية، emit error
      final savedUser = await userRepository.getSavedUser();
      if (savedUser != null) {
        emit(UserSuccess(savedUser));
      } else {
        emit(UserError(e.toString()));
      }
    }
  }

  Future<void> logout() async {
    try {
      await userRepository.logout(); // بيشيل user + token
      DioHelper_Products.token = null;
      emit(UserInitial());
    } catch (e) {
      print("Logout error: $e");
    }
    emit(UserInitial());
  }

  void setUser(User user) {
    emit(UserSuccess(user));
  }
}