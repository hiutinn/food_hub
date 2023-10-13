import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hub/constants/color.dart';
import 'package:food_hub/screens/sign_up_screen.dart';

final hidePasswordProvider = StateProvider<bool>((ref) => true);

class AuthFormInputField extends ConsumerWidget {
  const AuthFormInputField({
    super.key,
    required this.label,
    required this.placeHolder,
    required this.isPassword,
    required this.controller,
    required this.error
  });

  final String label;
  final String placeHolder;
  final bool isPassword;
  final TextEditingController controller;
  final String? error;
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
          TextField(
            controller: controller,
            onChanged: (value) {
              ref.invalidate(fullNameErrorProvider);
              ref.invalidate(emailErrorProvider);
              ref.invalidate(passwordErrorProvider);
            },
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 17.sp),
            obscureText: isPassword && hidePw,
            enableSuggestions: !isPassword,
            autocorrect: !isPassword,
            decoration: InputDecoration(
                errorText: error,
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
                        icon: const Icon(Icons.ac_unit_sharp),
                        onPressed: () {
                          ref
                              .read(hidePasswordProvider.notifier)
                              .update((state) => state = !state);
                        },
                      )
                    : null),
            onEditingComplete: () => ref
                .read(hidePasswordProvider.notifier)
                .update((state) => state = true),
          ),
        ],
      ),
    );
  }
}
