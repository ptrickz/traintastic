import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:traintastic/core/utils/constants/colors.dart';
import 'package:traintastic/firebase_options.dart';
import 'package:traintastic/presentation/screens/onboarding/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Traintastic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: CColors.primary),
        useMaterial3: true,
      ),
      home: const OnboardingPage(),
    );
  }
}
