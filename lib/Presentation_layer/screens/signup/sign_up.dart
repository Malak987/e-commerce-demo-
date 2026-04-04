import 'package:flutter/material.dart';

import '../../../styles/color.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/text_form_field/default_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            Image.asset("assets/images/signup.png",height: 200, ),

            const Center(
              child: Text(
                "Sign up",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left:25.0,right: 25,bottom: 10,top: 10),
              child: DefaultTextField(
                borderRadius: 20,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 0,
                ),
                width: double.infinity,
                label: "Email",
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {},
                prefixIcon: const Icon(Icons.email),
                fillColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 5), Padding(
              padding: const EdgeInsets.only(left:25.0,right: 25,bottom: 10,top: 10),
              child: DefaultTextField(
                borderRadius: 20,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 0,
                ),
                width: double.infinity,
                label: "Phone",
                hintText: "Enter your Phone",
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {},
                prefixIcon: const Icon(Icons.phone),
                fillColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 5),
             Padding(
              padding: const EdgeInsets.only(left:25.0,right: 25,bottom: 10,top: 10),
              child: DefaultTextField(
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
                onSubmitted: (value) {},

                prefixIcon: Icon(Icons.lock),
                fillColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left:25.0,right: 25,bottom: 10,top: 10),
              child: DefaultTextField(
                width: double.infinity,
                borderRadius: 20,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 0,
                ),
                label: "Password",
                hintText: "Enter your Current password",
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {},

                prefixIcon: Icon(Icons.lock),
                fillColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 10),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal:38.0),
              child: DefaultButton(
                elevation: 20,
                borderColor: primColor,
                borderWidth: 5,
                color: primColor,
                text: "Sign up",
                textFontSize: 18,
                textFontWeight: FontWeight.bold,
                onPressed: () {Navigator.pushNamed(context, "sign_up");},
                width: double.infinity,
                height: 60,
                radius: 20,
                textColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 38.0),
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
                    padding: EdgeInsets.only(right: 38.0),
                    child: Divider(thickness: 1, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(width: double.infinity,
                height: 60,
                child:  ElevatedButton.icon(
                  onPressed: () {Navigator.pushNamed(context, "sign_up");},
                  icon: Image.asset('assets/images/google.png', width: 20, height: 20), // حط صورتك هنا
                  label: const Text("Signup with Google"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87, // لون النص والأيقونة
                    side: const BorderSide(color: Colors.grey, width: 1), // الحدود الرمادية
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // الانحناء
                    ),
                    elevation: 0, // شيل الظل الافتراضي
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {},
                    child: Text("Login", style: TextStyle(color: primColor)),
                  ),
                ],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
             const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
