import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hub/constants/color.dart';
import 'package:reactive_forms/reactive_forms.dart';

final hidePasswordProvider = StateProvider<bool>((ref) => true);

class AuthFormInputField extends ConsumerWidget {
  const AuthFormInputField(
      {super.key,
      required this.label,
      required this.placeHolder,
      required this.isPassword,
      required this.formControlName,
      });

  final String label;
  final String placeHolder;
  final bool isPassword;
  final String formControlName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hidePw = ref.watch(hidePasswordProvider);
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                color: const Color(0XFF9796A1),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 8.h,
          ),
          ReactiveTextField(
            formControlName: formControlName,
            validationMessages: {
              'email': (error) => 'The email value must be a valid email',
              'required': (error) => 'The $label must not be empty'
            },
            onChanged: (value) {

            },
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 17.sp),
            obscureText: isPassword && hidePw,
            enableSuggestions: !isPassword,
            autocorrect: !isPassword,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColor.primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(10.0)),
                border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0XFFEEEEEE), width: 1),
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: placeHolder,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: hidePw
                            ? SvgPicture.asset('assets/icons/eye_open.svg')
                            : SvgPicture.asset('assets/icons/eye-closed.svg'),
                        onPressed: () {
                          ref
                              .read(hidePasswordProvider.notifier)
                              .update((state) => state = !state);
                        },
                      )
                    : null),
          ),
        ],
      ),
    );
  }
}
