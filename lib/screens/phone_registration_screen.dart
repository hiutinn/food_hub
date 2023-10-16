import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hub/main.dart';
import 'package:food_hub/providers/auth/auth_provider.dart';
import 'package:food_hub/screens/OTP_code_verify_screen.dart';
import 'package:food_hub/screens/shared/white_back_button.dart';
import 'package:food_hub/screens/shared/orange_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../constants/color.dart';

class PhoneRegistrationScreen extends ConsumerStatefulWidget {
  const PhoneRegistrationScreen({super.key});

  @override
  ConsumerState<PhoneRegistrationScreen> createState() =>
      _PhoneRegistrationScreenState();
}

class _PhoneRegistrationScreenState
    extends ConsumerState<PhoneRegistrationScreen> {
  final phoneNumberController = TextEditingController();
  String countryCode = '';

  Future sendPhoneOTPCode() async {
    if (phoneNumberController.text.isEmpty) return;
    String phoneNumWithoutCountryCode = phoneNumberController.text;
    if (phoneNumWithoutCountryCode[0] == '0') {
      phoneNumWithoutCountryCode = phoneNumWithoutCountryCode.substring(1);
    }
    String completedPhoneNumber = '+$countryCode$phoneNumWithoutCountryCode';
    ref.read(loadingProvider.notifier).update(
          (state) => state = true,
        );
    try {
      await ref.read(authNotifierProvider.notifier).sendOTPCode(
        completedPhoneNumber,
        (verificationId, resendToken) {
          ref.read(loadingProvider.notifier).update((state) => false);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                OTPCodeVerifyScreen(verificationId: verificationId),
          ));
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(phoneLoginVerificationId, (previous, next) {
      if (next != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OTPCodeVerifyScreen(
                  verificationId: next,
                )));
      }
    });
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/images/auth_top_bg.svg',
                fit: BoxFit.fill,
              ),
            ),
            const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: WhiteBackButton(),
                )),
            Container(
                padding: EdgeInsets.all(40.w),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Enter your phone number to verify your account",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0XFF9796A1),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Text(
                      "If your phone number start with 0, you should replace that 0 with your country code",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0XFF9796A1),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    IntlPhoneField(
                      keyboardType: TextInputType.number,
                      onCountryChanged: (value) => setState(() {
                        countryCode = value.code;
                      }),
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'VN',
                      onChanged: (phone) {},
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: OrangeButton(
                            title: "Send OTP code",
                            onPress: () {
                              sendPhoneOTPCode();
                            })),
                  ],
                )),
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
}
