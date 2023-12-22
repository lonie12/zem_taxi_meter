import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ept.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: Body(),
      debugShowCheckedModeBanner: false,
    );
  }
}
