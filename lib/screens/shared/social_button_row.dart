import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_hub/main.dart';
import 'package:food_hub/providers/auth/auth_provider.dart';
import 'package:food_hub/screens/shared/social_button.dart';

class SocialButtonRow extends ConsumerWidget {
  const SocialButtonRow({super.key});

  Future<void> _loginWithGoogle(BuildContext context, WidgetRef ref) async {
    ref.read(loadingProvider.notifier).update((state) => true);
    ref.read(authNotifierProvider.notifier).continueWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onPress: () {
                _loginWithGoogle(context, ref);
              },
            )),
      ],
    );
  }
}
