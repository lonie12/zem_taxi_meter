import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as Geo;
import 'package:get/get.dart';
import 'package:kokom/helper/helper.dart';
import 'package:kokom/utils.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';

class KokomSender extends StatefulWidget {
  const KokomSender({
    super.key,
    required this.baseprice,
    required this.kmprice,
  });
  final int baseprice;
  final int kmprice;
  @override
  State<KokomSender> createState() => _KokomSenderState();
}

class _KokomSenderState extends State<KokomSender> {
  final Location location = Location();
  StreamSubscription<LocationData>? locationSubscription;

  var userHasRide = false;
  var courseStarted = false;
  var streamConnected = false;
  List<double> originLocation = [0.0, 0.0];
  var rideDistance = 0.0;
  var rideBalance = 0;
  var basePrice = 50;

  final String userName = Random().nextInt(10000).toString();
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, ConnectionInfo> endpointMap = {};

  @override
  void initState() {
    // WakelockPlus.enable();
    super.initState();
  }

  @override
  dispose() {
    locationSubscription?.cancel();
    setState(() {
      locationSubscription = null;
    });
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
      // debugPrint(currentPosition.toString());
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
        var newBalance = basePrice * rideDistance.round();
        rideBalance = newBalance;
        setState(() {});

        endpointMap.forEach((key, value) {
          Nearby().sendBytesPayload(
            key,
            Uint8List.fromList(
              "$rideBalance|$rideDistance".codeUnits,
            ),
          );
        });
      } else {}
    });
  }

  Future<void> startCourse() async {
    var currentLocation = await Geo.Geolocator.getCurrentPosition();
    originLocation = [];
    originLocation = [currentLocation.latitude, currentLocation.longitude];
    // rideBalance = basePrice;
    await Nearby().stopDiscovery();
    await customStartDiscovery();
    courseStarted = true;
    setState(() {});
    begin();
  }

  Future<void> endCourse() async {
    locationSubscription?.cancel();

    setState(() {
      locationSubscription = null;
    });
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
                    Get.back();
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
                      Text(
                        "Distance parcourue",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF24292E),
                            ),
                      ),
                      Text(
                        "$rideDistance km",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF24292E),
                            ),
                      )
                    ],
                  ),
                ),
              ),
              !courseStarted
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
                  : Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(12),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
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
          Future.delayed(const Duration(seconds: 3), () {
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
      debugPrint("DISCOVERING: $a");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // void onConnectionInit() {
  void onConnectionInit(String id, ConnectionInfo info) {
    setState(() {
      endpointMap[id] = info;
    });
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
                  Nearby().acceptConnection(
                    id,
                    onPayLoadRecieved: (endid, payload) async {
                      if (payload.type == PayloadType.BYTES) {
                        // String str = String.fromCharCodes(payload.bytes!);
                        // showSnackbar("$endid: $str");

                        // if (str.contains(':')) {
                        //   // used for file payload as file payload is mapped as
                        //   // payloadId:filename
                        //   int payloadId = int.parse(str.split(':')[0]);
                        //   String fileName = (str.split(':')[1]);

                        //   if (map.containsKey(payloadId)) {
                        //     if (tempFileUri != null) {
                        //       moveFile(tempFileUri!, fileName);
                        //     } else {
                        //       showSnackbar("File doesn't exist");
                        //     }
                        //   } else {
                        //     //add to map if not already
                        //     map[payloadId] = fileName;
                        //   }
                        // }
                      } else if (payload.type == PayloadType.FILE) {
                        // showSnackbar("$endid: File transfer started");
                        // tempFileUri = payload.uri;
                      }
                    },
                    onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                      if (payloadTransferUpdate.status ==
                          PayloadStatus.IN_PROGRESS) {
                        // print(payloadTransferUpdate.bytesTransferred);
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.FAILURE) {
                        debugPrint("failed");
                        // showSnackbar("$endid: FAILED to transfer file");
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.SUCCESS) {
                        // showSnackbar(
                        //     "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");

                        // if (map.containsKey(payloadTransferUpdate.id)) {
                        //   //rename the file now
                        //   String name = map[payloadTransferUpdate.id]!;
                        //   moveFile(tempFileUri!, name);
                        // } else {
                        //   //bytes not received till yet
                        //   map[payloadTransferUpdate.id] = "";
                        // }
                      }
                    },
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
