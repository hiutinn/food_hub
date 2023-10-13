import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hub/firebase_options.dart';
import 'package:food_hub/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
          375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) =>  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food Hub',
        theme: ThemeData(
          fontFamily: 'Sofiapro',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: child,
      ),
      child: const SplashScreen(),
    );
  }
}
