import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokom/app/widgets/appbar.dart';
import 'package:kokom/app/widgets/input.dart';
import 'package:kokom/app/widgets/mybutton.dart';
import 'package:kokom/helper/helper.dart';
import 'package:kokom/helper/localstorage.dart';
import 'package:kokom/sender.dart';

class DefinePrice extends StatefulWidget {
  const DefinePrice({super.key});

  @override
  State<DefinePrice> createState() => _DefinePriceState();
}

class _DefinePriceState extends State<DefinePrice> {
  final TextEditingController basePriceController = TextEditingController();

  final TextEditingController kmPriceController = TextEditingController();

  LocalStorageManager localStorageManager = LocalStorageManager();

  @override
  void initState() {
    super.initState();
   
  }

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
                child: SingleChildScrollView(
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
                    Textarea(
                        "Entre votre tarif de base",
                        "title",
                        type: TextInputType.number,
                        basePriceController),
                    const SizedBox(height: 20),
                    Text(
                      "Prix par km",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Textarea(
                        "Entrer le prix par kilomètre",
                        "title",
                        type: TextInputType.number,
                        kmPriceController),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )),
            Container(
              padding: const EdgeInsets.all(12),
              child: MyButton(
                title: "Valider",
                color: Helper.primary,
                size: 32.0,
                width: 200.0,
                onClick: () async {
                  if (basePriceController.text.isEmpty ||
                      kmPriceController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Veillez définir vos tarifs',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    final int basePrice = int.parse(basePriceController.text);
                    final int kmPrice = int.parse(kmPriceController.text);
                    await localStorageManager.savePrices(basePrice, kmPrice);
                    Get.to(KokomSender(
                      baseprice: basePrice,
                      kmprice: kmPrice,
                    ));
                  }
                  //
                },
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
