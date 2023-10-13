import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hub/constants/color.dart';
import 'package:food_hub/screens/shared/social_button.dart';
import 'package:food_hub/screens/shared/text_divider.dart';
import 'package:food_hub/screens/sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  _buildSocialLoginButtons(),
                  SizedBox(
                    height: 24.h,
                  ),
                  _buildEmailPhoneLoginButton(context),
                  SizedBox(
                    height: 24.h,
                  ),
                  _buildBottomText(),
                ],
              ),
            ),
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

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex: 2,
            child: SocialButton(
              title: "FACEBOOK",
              icon: 'assets/images/facebook_icon.svg',
              onPress: () {},
            )),
        const Spacer(),
        Flexible(
            flex: 2,
            child: SocialButton(
              title: "GOOGLE",
              icon: 'assets/images/google_icon.svg',
              onPress: () {},
            )),
      ],
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
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SignUpScreen(),
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

  Widget _buildBottomText() {
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
