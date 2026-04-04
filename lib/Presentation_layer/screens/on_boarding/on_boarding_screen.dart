import 'package:e_commerce_prof/styles/color.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../login/login_screen.dart';



class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({required this.image, required this.title, required this.body});
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModel> boarding = [
    BoardingModel(
      image: "assets/onboarding/ordering.json",
      title: "Welcome to our app",
      body: "Let's get started",
    ),
    BoardingModel(
      image: "assets/onboarding/delivery.json",
      title: "Fast Delivery",
      body: "fast delivery with safty",
    ),
    BoardingModel(
      image: "assets/onboarding/cash-on-delivery.json",
      title: "Cash On Delivery",
      body: "Payment will be made upon receipt of the order.",
    ),
  ];

  final PageController boardController = PageController();

  bool isLast=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (route) => false,
                    );
                  },
                  child: Text("Skip"),
                ),
              ],
            ),
            Expanded(
              child: PageView.builder(
                onPageChanged: (int index) {
                  if(index== boarding.length-1){
                    setState(() {
                      isLast=true;
                    });
                  }else{ setState(() {
                    isLast=false;
                  });}
                },
                physics: BouncingScrollPhysics(),
                controller: boardController,
                itemBuilder: (context, index) => buildBoarding(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Spacer(),
                FloatingActionButton(
                  onPressed: () async {if(isLast==true){
                    // احفظ إن المستخدم شاف الـ OnBoarding
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('seen_onboarding', true);

                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (route) => false,
                    );
                  }else{
                    boardController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );}
                  },
                  backgroundColor: primColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            SmoothPageIndicator(
              controller: boardController,
              count: boarding.length,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: primColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildBoarding(BoardingModel model) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(child: Center(child: Lottie.asset(model.image))),
    Text(
      model.title,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    Text(
      model.body,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  ],
);
