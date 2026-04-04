import 'package:dio/dio.dart';
import 'package:e_commerce_prof/Business_logic_layer/login/login_cubit.dart';
import 'package:e_commerce_prof/Presentation_layer/screens/mainLayout/MainLayout.dart';
import 'package:e_commerce_prof/Presentation_layer/screens/products/products.dart';
import 'package:e_commerce_prof/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Business_logic_layer/user/user_cubit.dart';
import '../../../data_layer/user/user_repository.dart';
import '../../../data_layer/user/user_webservices.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/text_form_field/default_text_field.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        // ✅ هنا بنسمع للـ State ونعمل اللي عايزينه
        if (state is LoginSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login Success ✅"),
              backgroundColor: Colors.blue,
              behavior: SnackBarBehavior.floating,
            ),);
          // اللوجين نجح → نروح للمنتجات
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>  MainLayout()),
                (route) => false,
          );

        }

        if (state is LoginErrorState) {
          // اللوجين فشل → نعرض رسالة خطأ
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Email or Pass is Wrong"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(),
          body: Center(
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  Image.asset(
                    "assets/images/login.png",
                    height: 300,
                    fit: BoxFit.cover,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25.0,
                      right: 25,
                      bottom: 5,
                      top: 0,
                    ),
                    child: DefaultTextField(
                      controller: emailController,
                      validator: (v) {
                        if (v == null || v
                            .trim()
                            .isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                      borderRadius: 20,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 0,
                      ),
                      width: double.infinity,
                      label: "Email",
                      hintText: "Enter your email",
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (value) {},
                      prefixIcon: Icon(Icons.email),
                      fillColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25.0,
                      right: 25,
                      bottom: 0,
                      top: 10,
                    ),
                    child: DefaultTextField(
                      validator: (v) {
                        if (v == null || v
                            .trim()
                            .isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                      controller: passwordController,
                      width: double.infinity,
                      borderRadius: 20,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 0,
                      ),
                      label: "Password",
                      hintText: "Enter your password",
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icon(Icons.lock),
                      fillColor: Colors.transparent,
                      onSubmitted: (value) {
                        if (formKey.currentState!.validate()) {
                          LoginCubit.get(context).login(
                            username: emailController.text.trim(),
                            password: passwordController.text,
                          );

                        }
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: TextButton(
                          onPressed: () {},
                          child: Text("Forget Password"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 38.0),
                    child: DefaultButton(
                      elevation: 20,
                      borderColor: primColor,
                      borderWidth: 5,
                      color: primColor,
                      textFontSize: 18,
                      textFontWeight: FontWeight.bold,
                      onPressed: state is LoginLoadingState
                          ? null
                          : () {
                        if (formKey.currentState!.validate()) {
                          final cubit = LoginCubit.get(context);
                          cubit.login(
                            username: emailController.text.trim(),
                            password: passwordController.text,
                          );

                        }
                      },
                      width: double.infinity,
                      height: 60,
                      radius: 20,
                      textColor: Colors.white,
                      child: state is LoginLoadingState
                          ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 38.0),
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 38.0),
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, "sign_up");
                        },
                        icon: Image.asset(
                          'assets/images/google.png',
                          width: 20,
                          height: 20,
                        ),
                        // حط صورتك هنا
                        label: const Text("Login with Google"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          // لون النص والأيقونة
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          // الحدود الرمادية
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ), // الانحناء
                          ),
                          elevation: 0,
                          // شيل الظل الافتراضي
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Don’t have an account?"),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: primColor),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),

                  // SizedBox(height:10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
