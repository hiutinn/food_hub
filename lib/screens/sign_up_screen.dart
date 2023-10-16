import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hub/constants/color.dart';
import 'package:food_hub/main.dart';
import 'package:food_hub/providers/auth/auth_provider.dart';
import 'package:food_hub/screens/email_verify_screen.dart';
import 'package:food_hub/screens/log_in_screen.dart';
import 'package:food_hub/screens/phone_registration_screen.dart';
import 'package:food_hub/screens/shared/auth_form_input_field.dart';
import 'package:food_hub/screens/shared/orange_button.dart';
import 'package:food_hub/screens/shared/text_divider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'shared/social_button_row.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final form = FormGroup({
    'email': FormControl<String>(
        validators: [Validators.required, Validators.email]),
    'password': FormControl<String>(validators: [Validators.required]),
    'fullname': FormControl<String>(validators: [Validators.required]),
  });

  Future<void> _signup(WidgetRef ref, BuildContext context) async {
    form.controls.forEach((key, value) {
      value.markAsTouched();
    });
    if (form.hasErrors) return;
    ref.read(loadingProvider.notifier).update((state) => true);
    await ref
        .read(firebaseAuthServiceProvider)
        .signUpWithEmailAndPassword(
            email: form.control('email').value,
            password: form.control('password').value)
        .then((value) {
      ref.read(loadingProvider.notifier).update((state) => false);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const EmailVerifyScreen(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final generalError = ref.watch(signupGeneralErrorProvider);
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        unauthenticated: (message) {
          ref.read(loadingProvider.notifier).update((state) => false);
          ref
              .read(signupGeneralErrorProvider.notifier)
              .update((state) => message);
        },
        loading: () =>
            ref.read(loadingProvider.notifier).update((state) => true),
      );
    });
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
                      SizedBox(height: 60.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 36.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) =>
                                    const PhoneRegistrationScreen(),
                              ));
                            },
                            child: Text(
                              "Use phone number",
                              style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontSize: 16.sp,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColor.primaryColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.sp,
                      ),
                      _buildForm(ref),
                      SizedBox(
                        height: 16.h,
                      ),
                      if (generalError != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16.0.h),
                            child: Text(
                              generalError,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.center,
                        child: OrangeButton(
                          title: "SIGN UP",
                          onPress: () {
                            _signup(ref, context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      _buildLoginText(context, ref),
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
                      const SocialButtonRow()
                    ],
                  ),
                ),
              ),
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
      ),
    );
  }

  Widget _buildForm(WidgetRef ref) {
    return ReactiveForm(
      formGroup: form,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthFormInputField(
            label: "Full name",
            placeHolder: "Your full name",
            isPassword: false,
            formControlName: 'fullname',
          ),
          AuthFormInputField(
            label: "E-mail",
            placeHolder: "Your email or phone",
            isPassword: false,
            formControlName: 'email',
          ),
          AuthFormInputField(
            label: "Password",
            placeHolder: "Your email or phone",
            isPassword: true,
            formControlName: 'password',
          ),
        ],
      ),
    );
  }

  Widget _buildLoginText(BuildContext context, WidgetRef ref) {
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
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginScreen(),
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
}
