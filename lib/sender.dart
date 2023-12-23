import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as Geo;
import 'package:get/get.dart';
import 'package:kokom/app/pages/driver/defineprice.dart';
import 'package:kokom/helper/helper.dart';
import 'package:kokom/home.dart';
import 'package:kokom/utils.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';

class KokomSender extends StatefulWidget {
  const KokomSender({
    super.key,
    this.baseprice = 100,
    this.kmprice = 50,
  });
  final int? baseprice;
  final int? kmprice;
  @override
  State<KokomSender> createState() => _KokomSenderState();
}

class _KokomSenderState extends State<KokomSender> {
  final Location location = Location();
  StreamSubscription<LocationData>? locationSubscription;

  var startedValue = "not"; //on end ;
  var streamConnected = false;
  List<double> originLocation = [0.0, 0.0];
  var rideDistance = 0.0;
  var rideBalance = 0;

  final String userName = Random().nextInt(10000).toString();
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, ConnectionInfo> endpointMap = {};

  @override
  void initState() {
    WakelockPlus.enable();
    super.initState();
  }

  @override
  dispose() {
    locationSubscription?.cancel();
    locationSubscription = null;
    Nearby().stopDiscovery();
    Nearby().stopAllEndpoints();
    super.dispose();
  }

  Future<void> begin() async {
    await location.changeSettings(
      interval: 1000,
      // distanceFilter: 1000,
      accuracy: LocationAccuracy.high,
    );
    await listenLocation();
  }

  Future<dynamic> listenLocation() async {
    locationSubscription = location.onLocationChanged.handleError((onError) {
      locationSubscription?.cancel();
    }).listen((LocationData currentLocation) async {
      var currentPosition = await Geo.Geolocator.getCurrentPosition();
      debugPrint(currentPosition.toString());
      double distanceInMeters = Geo.Geolocator.distanceBetween(
        originLocation[0],
        originLocation[1],
        currentPosition.latitude,
        currentPosition.longitude,
      );

      // Convertir la distance en kilomètres
      double distanceInKm = distanceInMeters / 1000;

      if (distanceInKm >= 1) {
        originLocation = [];
        // Mettre à jour la distance parcourue
        rideDistance += distanceInKm;
        originLocation = [
          currentPosition.latitude,
          currentPosition.longitude,
        ];

        // Mettre à jour le solde et l'interface utilisateur
        rideBalance += widget.kmprice! * rideDistance.round();
        setState(() {});

        // Send to clients
        endpointMap.forEach((key, value) {
          Nearby().sendBytesPayload(
            key,
            Uint8List.fromList("$rideBalance|$rideDistance".codeUnits),
          );
        });
      } else {}
    });
  }

  Future<void> startCourse() async {
    var currentLocation = await Geo.Geolocator.getCurrentPosition();
    originLocation = [];
    originLocation = [currentLocation.latitude, currentLocation.longitude];
    rideBalance = widget.baseprice!;
    await Nearby().stopDiscovery();
    Nearby().stopAllEndpoints();
    await customStartDiscovery();
    startedValue = "on";
    setState(() {});
    begin();
  }

  Future<void> endCourse() async {
    Nearby().stopDiscovery();
    locationSubscription?.cancel();
    setState(() {
      locationSubscription = null;
    });
    startedValue = "end";
  }

  @override
  Widget build(context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () async {
                    await endCourse();
                    Get.offAll(const Home());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Text(
                      "Quitter",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 16,
                          color: Helper.danger,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(width: 5, color: Helper.primary),
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.shade300,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "$rideBalance",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF24292E),
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "FCFA",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 15,
                                      color: const Color(0xFF24292E)
                                          .withOpacity(0.8),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      startedValue == "on"
                          ? Text(
                              "Distance parcourue",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF24292E),
                                  ),
                            )
                          : const SizedBox(),
                      startedValue == "on"
                          ? Text(
                              "$rideDistance km",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF24292E),
                                  ),
                            )
                          : const SizedBox(),
                      startedValue == "end"
                          ? Text(
                              "Course terminée",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                            )
                          : const SizedBox(),
                      startedValue == "end"
                          ? Text(
                              "Distance total",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Helper.primary,
                                  ),
                            )
                          : const SizedBox(),
                      startedValue == "end"
                          ? Text(
                              "$rideDistance km",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Helper.primary,
                                  ),
                            )
                          : const SizedBox(),
                      startedValue == "not"
                          ? Text(
                              "Prix de base: ${widget.baseprice} F",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Helper.primary,
                                  ),
                            )
                          : const SizedBox(),
                      startedValue == "not"
                          ? Text(
                              "Prix par Km: ${widget.kmprice} F",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Helper.primary,
                                  ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 12),
                      startedValue == "not"
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Helper.otherPrimaryColor),
                              ),
                              onPressed: () => Get.to(const DefinePrice()),
                              child: const Text("Modifier"),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              startedValue == "not"
                  ? Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        border: Border.all(width: 5, color: Helper.warning),
                        borderRadius: BorderRadius.circular(130),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: InkWell(
                        onTap: () => startCourse(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Helper.primary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              "Go",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontSize: 22, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  : startedValue == "on"
                      ? Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(12),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Helper.danger),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 11),
                              ),
                            ),
                            child: Text(
                              "Terminer la course !",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () => endCourse(),
                          ),
                        )
                      : const SizedBox()
              // : Container(
              //     width: Get.width,
              //     padding: const EdgeInsets.all(12),
              //     child: ElevatedButton(
              //       style: ButtonStyle(
              //         backgroundColor:
              //             MaterialStateProperty.resolveWith(
              //                 (states) => Helper.primary),
              //         padding: MaterialStateProperty.all(
              //           const EdgeInsets.symmetric(vertical: 11),
              //         ),
              //       ),
              //       child: Text(
              //         "Recommencer une course !",
              //         style: Theme.of(context)
              //             .textTheme
              //             .bodyLarge!
              //             .copyWith(color: Colors.white, fontSize: 16),
              //       ),
              //       onPressed: () => Get.off(
              //         () => const KokomSender(
              //           baseprice: 0,
              //           kmprice: 0,
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> customStartDiscovery() async {
    try {
      bool a = await Nearby().startDiscovery(
        userName,
        strategy,
        onEndpointFound: (id, name, serviceId) {
          Future.delayed(const Duration(seconds: 4), () {
            Nearby().requestConnection(
              userName,
              id,
              onConnectionInitiated: (id, info) {
                onConnectionInit(id, info);
              },
              onConnectionResult: (id, status) {
                debugPrint("Driver connected");
                streamConnected = true;
                debugPrint(status.toString());
                showSnackbar(context, "Client Connecté");
                setState(() {});
              },
              onDisconnected: (id) {
                setState(() {
                  endpointMap.remove(id);
                });
                debugPrint(
                  "Disconnected from: ${endpointMap[id]!.endpointName}, id $id",
                );
              },
            );
          });
        },
        onEndpointLost: (id) {
          debugPrint(
            "Lost discovered Endpoint: ${endpointMap[id]?.endpointName}, id $id",
          );
        },
      );
      debugPrint("DRIVER DISCOVERING: $a");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // void onConnectionInit() {
  void onConnectionInit(String id, ConnectionInfo info) {
    setState(() {
      endpointMap[id] = info;
    });
    debugPrint("$id ${info.endpointName.toString()}");
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(12),
          width: Get.width,
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Demande de connexion",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF24292E),
                  fontFamily: "Poppins",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Nearby().acceptConnection(
                    id,
                    onPayLoadRecieved: (endid, payload) async {},
                    onPayloadTransferUpdate: (endid, payloadTransferUpdate) {},
                  );
                },
                child: const Text("Accepter"),
              )
            ],
          ),
        );
      },
    );
  }
}
