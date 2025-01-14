import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokom/app/pages/home/about.dart';
import 'package:kokom/helper/helper.dart';
import 'package:kokom/app/pages/customer/receiver.dart';
import 'package:kokom/app/pages/driver/sender.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final shorebirdCodePush = ShorebirdCodePush();

  @override
  void initState() {
    onInit();
    super.initState();
  }

  Future<void> checkForUpdates() async {
    final isUpdateAvailable =
        await shorebirdCodePush.isNewPatchAvailableForDownload();
    if (isUpdateAvailable) {
      await shorebirdCodePush.downloadUpdateIfAvailable();
    }
  }

  Future<void> onInit() async {
    await checkForUpdates();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Helper.warning),
                        borderRadius: BorderRadius.circular(150),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Image(
                          image: AssetImage(Helper.appicon),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    //   const SizedBox(height: 15),
                    // Text(
                    //   "Version 1.0.0 (Beta)",
                    //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //       color: Helper.greyTextColor),
                    // ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => Get.to(const About()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Text(
                          "A propos",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Helper.greyTextColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: Text(
                "Hellooo, Lémaa ?",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Helper.otherPrimaryColor),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Helper.primary),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      child: Text(
                        "Driver",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () => Get.to(
                        () => const KokomSender(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Helper.warning),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      child: Text(
                        "Customer",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () => Get.to(() => const KokomReceiver()),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
