import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hub/constants/color.dart';
import 'package:food_hub/main.dart';
import 'package:food_hub/providers/auth/auth_provider.dart';
import 'package:food_hub/screens/log_in_screen.dart';
import 'package:food_hub/screens/shared/text_divider.dart';
import 'package:food_hub/screens/sign_up_screen.dart';

import 'home_screen.dart';
import 'shared/social_button_row.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        authenticated: (user) {
          ref.read(loadingProvider.notifier).update((state) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User Logged In From Welcome'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false);
        },
        unauthenticated: (message) {
          ref.read(loadingProvider.notifier).update((state) => false);
          ref
              .read(loginGeneralErrorProvider.notifier)
              .update((state) => message);
        },
        loading: () =>
            ref.read(loadingProvider.notifier).update((state) => true),
      );
    });
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
                child: Image.asset(
              'assets/images/welcome_bg.png',
              fit: BoxFit.fill,
            )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 26.h),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                const Color(0XFF494D63).withOpacity(0.1),
                const Color(0XFF191B2F)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: SkipButton(),
                  ),
                  _buildWelcomeText(),
                  _buildTextDivider(),
                  SizedBox(
                    height: 18.h,
                  ),
                  const SocialButtonRow(),
                  SizedBox(
                    height: 24.h,
                  ),
                  _buildEmailPhoneLoginButton(context),
                  SizedBox(
                    height: 24.h,
                  ),
                  _buildBottomText(context),
                ],
              ),
            ),
            if (ref.watch(loadingProvider))
              Positioned.fill(
                  child: Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                    strokeWidth: 5.0,
                  ),
                ),
              ))
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Welcome to",
          style: TextStyle(
            color: Colors.black,
            fontSize: 45.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "FoodHub",
          style: TextStyle(
            color: AppColor.primaryColor,
            fontSize: 45.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "Your favourite foods delivered fast at your door.",
          style: TextStyle(
            color: const Color(0XFF30384F),
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ));
  }

  Widget _buildTextDivider() {
    return TextDivider(
      text: "Sign in with",
      fontSize: 16.sp,
      textColor: Colors.white,
    );
  }

  Widget _buildEmailPhoneLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.white, width: 1),
          ),
          padding: EdgeInsets.symmetric(vertical: 18.h),
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const SignUpScreen(),
          ));
        },
        child: Text(
          "Start with email or phone",
          style: TextStyle(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildBottomText(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account?",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 6.w,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
            child: Text(
              "Sign In",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  decorationThickness: 2),
            ),
          ),
        ],
      ),
    );
  }
}

class SkipButton extends StatelessWidget {
  const SkipButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8.sp)),
      onPressed: () {},
      child: Text(
        "Skip",
        style: TextStyle(color: AppColor.primaryColor, fontSize: 14.sp),
      ),
    );
  }
}
