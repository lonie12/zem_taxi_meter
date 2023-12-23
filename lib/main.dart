import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokom/ept.dart';
import 'package:kokom/helper/localstorage.dart';
import 'package:kokom/home.dart';
import 'package:kokom/onboarding.dart';
import 'package:kokom/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocalStorageManager localStorageManager = LocalStorageManager();
  bool? permission =
      await localStorageManager.getEnablePermissions('permission');

  runApp(MainApp(permission: permission ?? false));
}

class MainApp extends StatelessWidget {
  final bool permission;

  const MainApp({required this.permission, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      title: "Vooom",
      theme: appTheme,
      home: permission ? const Home() : const OnBoarding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
