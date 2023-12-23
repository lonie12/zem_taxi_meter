import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokom/helper/app.dart';
import 'package:kokom/app/pages/home/home.dart';
import 'package:kokom/app/layout/onboarding.dart';
import 'package:kokom/helper/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appData = await App.initialize();
  runApp(MainApp(permission: appData.permission));
}

class MainApp extends StatelessWidget {
  final bool permission;

  const MainApp({required this.permission, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: staticTheme,
      title: "Vooom",
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: permission ? const Home() : const OnBoarding(),
    );
  }
}
