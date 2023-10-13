import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hub/constants/color.dart';

class OrangeButton extends StatelessWidget {
  const OrangeButton({
    super.key,
    required this.title,
    required this.onPress,
  });

  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 68.w)),
        onPressed: onPress,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ));
  }
}
