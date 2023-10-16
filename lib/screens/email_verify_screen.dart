import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hub/constants/color.dart';
import 'package:food_hub/screens/log_in_screen.dart';
import 'package:food_hub/screens/shared/orange_button.dart';

class EmailVerifyScreen extends StatelessWidget {
  const EmailVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(40.w),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.mark_email_unread,
                color: AppColor.primaryColor,
                size: 48.sp,
              ),
              Text(
                "Check your email",
                style: TextStyle(fontSize: 20.sp),
              ),
              SizedBox(
                height: 16.h,
              ),
              const Text(
                  "We've sent you an email to verify your email, please check it out"),
              SizedBox(
                height: 16.h,
              ),
              OrangeButton(
                  title: "Back to login",
                  onPress: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
