import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({
    super.key, required this.text, required this.fontSize, required this.textColor,
  });
  final String text;
  final double fontSize;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const Expanded(child: Divider()),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: fontSize),
        ),
      ),
      const Expanded(child: Divider()),
    ]);
  }
}