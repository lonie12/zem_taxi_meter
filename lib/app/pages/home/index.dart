import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokom/app/pages/customer/customer.dart';
import 'package:kokom/app/pages/driver/index.dart';
import 'package:kokom/app/widgets/mybutton.dart';
import 'package:kokom/helper/helper.dart';

// ignore: must_be_immutable
class HomeIndex extends StatelessWidget {
  const HomeIndex({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Center(
                //   child: SvgPicture.asset(
                //     Helper.welcome,
                //     height: 300,
                //   ),
                // ),
                Text(
                  "Vooom",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins"),
                ),
                Text(
                  "Lorem ipsum oklm.",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Helper.greyTextColor,
                      fontSize: 14,
                      fontFamily: "Poppins"),
                ),
                const SizedBox(height: 20),
                MyButton(
                  title: "Chauffeur",
                  color: Helper.primary,
                  size: 32.0,
                  width: 200.0,
                  onClick: () => Get.to(const DriverIndex()),
                ),
                const SizedBox(height: 10),
                MyButton(
                  title: "Client",
                  color: Helper.blue,
                  size: 32.0,
                  width: 200.0,
                  onClick: () => Get.to(const CustomerIndex()),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
