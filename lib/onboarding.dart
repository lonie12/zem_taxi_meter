import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokom/ept.dart';
import 'package:kokom/helper/helper.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                pageSnapping: false,
                physics: const NeverScrollableScrollPhysics(),
                // allowImplicitScrolling: true,
                controller: _controller,
                itemCount: 3,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Helper.warning.withOpacity(0.3),
                            border: Border.all(
                              width: 5,
                              color: const Color(0XFF5F748A),
                            ),
                            borderRadius: BorderRadius.circular(200),
                          ),
                        ),
                        const SizedBox(height: 35),
                        Text(
                          "Votre position",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Helper.primary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          Helper.lorem,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Helper.greyColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => buildDot(index, context),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              width: Get.width,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Helper.primary),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                child: Text(
                  "Suivant",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white, fontSize: 16),
                ),
                onPressed: () => onClickCustom(currentIndex),
              ),
              // Button(
              //   title:
              //       currentIndex == contents.length - 1 ? "Terminé" : "Suivant",
              //   background: Helper.primary,
              //   foreground: Colors.white,
              //   onClick: () {
              //     if (currentIndex == contents.length - 1) {
              //       Get.to(() => const MidjoPartnerPermissions());
              //     }
              //     _controller.nextPage(
              //       duration: const Duration(milliseconds: 100),
              //       curve: Curves.bounceIn,
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }

  onClickCustom(currentIndex) async {
    switch (currentIndex) {
      case 0:
        var locationPermission = await Permission.location.isGranted;
        if (!locationPermission) {
          return await Permission.location.request();
        }
        goToNexPage();
        break;
      case 1:
        if ((await Future.wait([
          Permission.bluetooth.isGranted,
          Permission.bluetoothAdvertise.isGranted,
          Permission.bluetoothConnect.isGranted,
          Permission.bluetoothScan.isGranted,
        ]))
            .any((element) => false)) {
          return [
            Permission.bluetooth,
            Permission.bluetoothAdvertise,
            Permission.bluetoothConnect,
            Permission.bluetoothScan
          ].request();
        }
        goToNexPage();
        break;
      case 2:
        // var nearbyWifiPermission = await Permission.nearbyWifiDevices.isGranted;
        var locationServiceEnabled = await Location.instance.serviceEnabled();
        // if (!nearbyWifiPermission) {
        //   return await Permission.nearbyWifiDevices.request();
        // }
        if (!locationServiceEnabled) {
          return await Location.instance.requestService();
        }
        Get.offAll(const Body());
        break;
      default:
        return false;
    }
  }

  goToNexPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 100),
      curve: Curves.bounceIn,
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 8,
      // width: currentIndex == index ? 25 : 10,
      width: 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index
            ? Helper.warning
            : Theme.of(context).primaryColor,
      ),
    );
  }
}
