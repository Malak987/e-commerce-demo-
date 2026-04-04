import 'package:e_commerce_prof/data_layer/helper/dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data_layer/user/user_repository.dart';
import '../../networks/end_points.dart';
import '../../styles/string.dart' as userRepository;
import '../user/user_cubit.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
   UserRepository userRepository;
   final UserCubit userCubit;
  LoginCubit({ required this.userRepository, required this.userCubit}) : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void login({required String username, required String password})async {
    emit(LoginLoadingState());


    try {
      final user = await userRepository.login(username: username, password: password);

      if (user.accessToken != null) {
        DioHelper_Products.setToken(user.accessToken!);
      }

      // لو عايز تخلي UserCubit يعرف اليوزر
      userCubit.setUser(user);
      emit(LoginSuccessState());
    } catch (error) {
      emit(LoginErrorState(error.toString()));
    }}
}
