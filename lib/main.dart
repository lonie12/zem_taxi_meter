import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokom/onboarding.dart';
import 'package:kokom/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: appTheme,
      home: const OnBoarding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
