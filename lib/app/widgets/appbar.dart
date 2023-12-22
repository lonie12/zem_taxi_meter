import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: non_constant_identifier_names
Widget Appbar(
  String title, {
  Widget actions = const SizedBox(),
  bool backbutton = false,
  Function? backaction,
}) {
  //
  return Builder(
    builder: (context) {
      return Container(
        height: 56,
        width: Get.width,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                backbutton
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              backaction != null ? backaction() : Get.back();
                            },
                            child: const Icon(CarbonIcons.arrow_left),
                          ),
                          const SizedBox(width: 10)
                        ],
                      )
                    : const SizedBox(),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins"),
                ),
              ],
            ),
            actions,
          ],
        ),
      );
    },
  );
}
