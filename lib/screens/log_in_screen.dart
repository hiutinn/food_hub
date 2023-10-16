import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hub/constants/color.dart';
import 'package:food_hub/main.dart';
import 'package:food_hub/providers/auth/auth_provider.dart';
import 'package:food_hub/screens/home_screen.dart';
import 'package:food_hub/screens/shared/auth_form_input_field.dart';
import 'package:food_hub/screens/shared/orange_button.dart';
import 'package:food_hub/screens/shared/social_button_row.dart';
import 'package:food_hub/screens/shared/text_divider.dart';
import 'package:food_hub/screens/shared/white_back_button.dart';
import 'package:food_hub/screens/sign_up_screen.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  final form = FormGroup({
    'email': FormControl<String>(
        validators: [Validators.required, Validators.email]),
    'password':
        FormControl<String>(validators: [Validators.required]),
  });

  Future<void> _login(WidgetRef ref, BuildContext context) async {
    form.controls.forEach((key, value) {value.markAsTouched();});
    if (form.hasErrors) return;
    await ref.read(authNotifierProvider.notifier).login(
        email: form.control('email').value,
        password: form.control('password').value);
  }


  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        authenticated: (user) {
          ref.read(loadingProvider.notifier).update((state) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User Logged In From Login'),
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
          ref
              .read(loginGeneralErrorProvider.notifier)
              .update((state) => message);
        },
        loading: () =>
            ref.read(loadingProvider.notifier).update((state) => true),
      );
    });
    final generalError = ref.watch(loginGeneralErrorProvider);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          body: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: Stack(
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
                        SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.12),
                        Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        _buildForm(ref),
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
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              "Forgot password",
                              style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: OrangeButton(
                            title: "LOG IN",
                            onPress: () {
                              _login(ref, context);
                              // FirebaseAuthService.signUpWithEmailAndPassword(email, password);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        _buildSignupText(),
                        SizedBox(
                          height: 36.h,
                        ),
                        TextDivider(
                          text: "Sign in with",
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
      ),
    );
  }

  Widget _buildForm(WidgetRef ref) {
    return ReactiveForm(
      formGroup: form,
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AuthFormInputField(
          label: "E-mail",
          placeHolder: "Your email or phone",
          isPassword: false,
          formControlName: 'email',
        ),
        AuthFormInputField(
          label: "Password",
          placeHolder: "Password",
          isPassword: true,
          formControlName: 'password',
        ),
      ]),
    );
  }

  Widget _buildSignupText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
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
              builder: (context) => const SignUpScreen(),
            ));
          },
          child: Text(
            "Sign up",
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
