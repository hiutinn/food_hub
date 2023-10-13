import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialButton extends StatelessWidget {
  const SocialButton(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress});

  final String title;
  final String icon;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: 14.sp),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0))),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                width: 30.w,
                height: 30.h,
                child: SvgPicture.asset(icon)),
            // SizedBox(width: 4.sp,),
            Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ));
  }
}
