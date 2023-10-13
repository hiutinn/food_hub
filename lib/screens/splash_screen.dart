import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hub/constants/color.dart';
import 'package:food_hub/screens/home_screen.dart';
import 'package:food_hub/screens/sign_up_screen.dart';
import 'package:food_hub/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Center(
        child: SvgPicture.asset('assets/images/food_hub_logo.svg'),
      ),
    );
  }
}
