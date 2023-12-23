import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokom/ept.dart';
import 'package:kokom/helper/helper.dart';
import 'package:kokom/helper/localstorage.dart';
import 'package:kokom/home.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:localstorage/localstorage.dart';

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
                          child: Lottie.asset(
                            getImage(),
                            width: 200,
                            height: 200,
                          ),
                        ),
                        const SizedBox(height: 35),
                        Text(
                          getText(),
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
                          getDescription(),
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
                  currentIndex != 2 ? "Suivant" : "Terminé",
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
        var bluetoothPermission = (await Future.wait([
          Permission.bluetooth.isGranted,
          Permission.bluetoothAdvertise.isGranted,
          Permission.bluetoothConnect.isGranted,
          Permission.bluetoothScan.isGranted,
        ]))
            .any((element) => false);
        if (bluetoothPermission) {
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
        var isNearbyWifiOptional =
            await Permission.nearbyWifiDevices.isProvisional;
        if (!isNearbyWifiOptional) {
        } else {
          var nearbyWifiDevicesPermission =
              await Permission.nearbyWifiDevices.isGranted;
          if (!nearbyWifiDevicesPermission) {
            return await Permission.nearbyWifiDevices.request();
          }
        }
        var locationServiceEnabled = await Location.instance.serviceEnabled();
        if (!locationServiceEnabled) {
          return await Location.instance.requestService();
        }
        savePermission();
        Get.offAll(const Home());
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

  Future<void> savePermission() async {
    LocalStorageManager localStorageManager = LocalStorageManager();
    await localStorageManager.saveEnablePermissions('permission', true);
  }

  String getText() {
    switch (currentIndex) {
      case 0:
        return "Position";
      case 1:
        return "Bluetooth";
      case 2:
        return "Cast";
      default:
        return "Autres";
    }
  }

  String getDescription() {
    switch (currentIndex) {
      case 0:
        return "L'autorisation de Position est indispensable pour calculer avec précision le coût et la distance de votre trajet, en se basant sur les points de départ et d'arrivée du client.";
      case 1:
        return "L'autorisation Bluetooth est requise pour établir une connexion entre le smartphone du client et le chauffeur ou le conducteur de zem.";
      case 2:
        return "L'autorisation de Cast est nécessaire pour diffuser les informations tarifaires de base, le coût par kilomètre, ainsi que le prix et la distance parcourue pendant le trajet entre le client et le chauffeur ou le conducteur de zem.";
      default:
        return "Autre";
    }
  }

  String getImage() {
    switch (currentIndex) {
      case 0:
        return Helper.onboard0;
      case 1:
        return Helper.onboard1;
      case 2:
        return Helper.onboard2;
      default:
        return "";
    }
  }
}
