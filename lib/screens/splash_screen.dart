import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hub/constants/color.dart';
import 'package:food_hub/providers/auth/auth_provider.dart';
import 'package:food_hub/screens/home_screen.dart';
import 'package:food_hub/screens/sign_up_screen.dart';
import 'package:food_hub/screens/welcome_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (previous, next) {
      Future.delayed(
          const Duration(seconds: 2),
              () => next.whenData((value) => value != null
              ? Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
                  (route) => false)
              : Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => WelcomeScreen(),
              ),
                  (route) => false)));
    });
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Center(
        child: SvgPicture.asset('assets/images/food_hub_logo.svg'),
      ),
    );
  }
}
