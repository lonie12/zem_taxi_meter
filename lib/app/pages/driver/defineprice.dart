import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokom/app/widgets/appbar.dart';
import 'package:kokom/app/widgets/input.dart';
import 'package:kokom/app/widgets/mybutton.dart';
import 'package:kokom/helper/helper.dart';
import 'package:kokom/sender.dart';

class DefinePrice extends StatelessWidget {
  const DefinePrice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Appbar("Tarifs", backbutton: true),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Entrez ci-dessous votre prix de base, et votre prix par km en le confirmant pour continuer.",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    color: Helper.greyTextColor),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //      const SizedBox(height: 10),
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   padding: const EdgeInsets.symmetric(horizontal: 12),
                  //   child: Text(
                  //     "Tarifs",
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold,
                  //       color: Helper.textColor,
                  //     ),
                  //     textAlign: TextAlign.start,
                  //   ),
                  // ),

                  const SizedBox(height: 20),
                  Text(
                    "Tarif de base",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Textarea("Entre votre tarif de base", "title",
                      TextEditingController()),
                  const SizedBox(height: 20),
                  Text(
                    "Prix par km",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Textarea("Entrer le prix par kilomètre", "title",
                      TextEditingController()),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                ],
              ),
            )),
            Container(
              padding: const EdgeInsets.all(12),
              child: MyButton(
                title: "Valider",
                color: Helper.primary,
                size: 32.0,
                width: 200.0,
                onClick: () => Get.to(const KokomSender()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    return Future.value(false);
  }
}
