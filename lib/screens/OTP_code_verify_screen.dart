import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hub/main.dart';
import 'package:food_hub/providers/auth/auth_provider.dart';
import 'package:food_hub/screens/shared/orange_button.dart';
import 'package:food_hub/screens/shared/white_back_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'home_screen.dart';

class OTPCodeVerifyScreen extends ConsumerStatefulWidget {
  const OTPCodeVerifyScreen({super.key, required this.verificationId});

  final String verificationId;

  @override
  ConsumerState<OTPCodeVerifyScreen> createState() =>
      _OTPCodeVerifyScreenState();
}

class _OTPCodeVerifyScreenState extends ConsumerState<OTPCodeVerifyScreen> {
  final otpCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        authenticated: (user) {
          ref.read(loadingProvider.notifier).update((state) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User Logged In'),
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
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Something went wrong!!!'),
                content: Text('$message'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close')),
                ],
              );
            },
          );
        },
        loading: () =>
            ref.read(loadingProvider.notifier).update((state) => true),
      );
    });
    return Scaffold(
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
                    'Vefification Code',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "We've sent an OTP code to your phone number. Enter the code to verify your account.",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0XFF9796A1),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: otpCodeController,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: OrangeButton(
                          title: "Verify",
                          onPress: () {
                            ref
                                .read(authNotifierProvider.notifier)
                                .verifyOTPCode(widget.verificationId,
                                    otpCodeController.text);
                          })),
                ],
              )),
        ],
      ),
    );
  }
}
