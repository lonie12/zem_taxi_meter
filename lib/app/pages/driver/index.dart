import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokom/app/pages/driver/driverlive.dart';
import 'package:kokom/app/widgets/go.dart';

// ignore: must_be_immutable
class DriverIndex extends StatelessWidget {
  const DriverIndex({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Center(
                //   child: SvgPicture.asset(
                //     Helper.welcome,
                //     height: 300,
                //   ),
                // ),
                InkWell(onTap: () => Get.to(const DriverLive()), child: const Go())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
