import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hub/constants/color.dart';
import 'package:food_hub/network/firebase_auth_service.dart';
import 'package:food_hub/screens/log_in_screen.dart';
import 'package:food_hub/screens/shared/auth_form_input_field.dart';
import 'package:food_hub/screens/shared/orange_button.dart';
import 'package:food_hub/screens/shared/social_button.dart';
import 'package:food_hub/screens/shared/text_divider.dart';

import 'home_screen.dart';

final fullNameProvider = StateProvider((ref) => TextEditingController());
final emailProvider = StateProvider((ref) => TextEditingController());
final passwordProvider = StateProvider((ref) => TextEditingController());
final fullNameErrorProvider = StateProvider<String?>((ref) => null);
final emailErrorProvider = StateProvider<String?>((ref) => null);
final passwordErrorProvider = StateProvider<String?>((ref) => null);

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  Future<void> _signup(WidgetRef ref, BuildContext context) async {
    final fullName = ref.read(fullNameProvider).text;
    final email = ref.read(emailProvider).text;
    final password = ref.read(passwordProvider).text;

    if (fullName.isEmpty) {
      ref
          .read(fullNameErrorProvider.notifier)
          .update((state) => state = "Đôn't đu dịt");
      return;
    }

    await ref
        .read(firebaseAuthServiceProvider)
        .signUpWithEmailAndPassword(email, password)
        .then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Sign up successfully")));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen(),), (
          route) => false);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
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
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 26.sp, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.12),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      _buildForm(ref),
                      SizedBox(
                        height: 16.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: OrangeButton(
                          title: "SIGN UP",
                          onPress: () {
                            _signup(ref, context);
                            // FirebaseAuthService.signUpWithEmailAndPassword(email, password);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      _buildLoginText(context),
                      SizedBox(
                        height: 36.h,
                      ),
                      TextDivider(
                        text: "Sign up with",
                        fontSize: 14.sp,
                        textColor: const Color(0XFF5B5B5E),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      _buildSocialLoginButtons()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildForm(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthFormInputField(
          label: "Full name",
          placeHolder: "Your full name",
          isPassword: false,
          controller: ref.watch(fullNameProvider),
          error: ref.watch(fullNameErrorProvider),
        ),
        AuthFormInputField(
          label: "E-mail",
          placeHolder: "Your email or phone",
          isPassword: false,
          controller: ref.watch(emailProvider),
          error: ref.watch(emailErrorProvider),
        ),
        AuthFormInputField(
          label: "Password",
          placeHolder: "Your email or phone",
          isPassword: true,
          controller: ref.watch(passwordProvider),
          error: ref.watch(passwordErrorProvider),
        ),
      ],
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: TextStyle(
              color: const Color(0XFF5B5B5E),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          width: 4.w,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
          },
          child: Text(
            "Login",
            style: TextStyle(
                color: AppColor.primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
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
}
