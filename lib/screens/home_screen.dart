import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_hub/providers/auth/auth_provider.dart';
import 'package:food_hub/screens/welcome_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You want to sign out ?'),
          content: const Text('Are you sure ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(authNotifierProvider.notifier)
                    .signOut(); // Close the dialog
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                    (route) => false);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Sign Out"),
          onPressed: () {
            signOut(context, ref);
          },
        ),
      ),
    );
  }
}
