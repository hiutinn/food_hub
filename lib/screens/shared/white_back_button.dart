import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WhiteBackButton extends StatelessWidget {
  const WhiteBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
          width: 38.0.w,
          height: 38.0.h,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(5,10),
                    blurRadius: 20,
                    spreadRadius: 0,
                    color: const Color(0XFFD3D1D8).withOpacity(0.3)
                )
              ]
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 14.sp,
          )),
    );
  }
}