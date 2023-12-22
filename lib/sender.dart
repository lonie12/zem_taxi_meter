import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kokom/app/widgets/mybutton.dart';
import 'package:kokom/helper/helper.dart';
import 'package:kokom/utils.dart';
import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';

class KokomSender extends StatefulWidget {
  const KokomSender(
      {super.key, required this.baseprice, required this.kmprice});
  final int baseprice;
  final int kmprice;
  @override
  State<KokomSender> createState() => _KokomSenderState();
}

class _KokomSenderState extends State<KokomSender> {
  final Location location = Location();
  StreamSubscription<LocationData>? locationSubscription;

  var userHasRide = false;
  var streamConnected = false;
  var courseStarted = false;
  var rideDistance = 0;
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
      interval: 10000,
      accuracy: LocationAccuracy.high,
    );
    await listenLocation();
  }

  Future<dynamic> listenLocation() async {
    locationSubscription = location.onLocationChanged.handleError((onError) {
      locationSubscription?.cancel();
    }).listen((LocationData currentlocation) async {
      // debugPrint(currentlocation.toString());
      rideDistance = rideDistance + 1;
      var newBalance = basePrice * rideDistance;
      rideBalance = newBalance;
      setState(() {});
      endpointMap.forEach((key, value) {
        // String a = Random().nextInt(100).toString();
        // showSnackbar("Sending $a to ${value.endpointName}, id: $key");
        // rideDistance = rideDistance + 1;
        // var newBalance = basePrice * rideDistance;
        // rideBalance = newBalance;
        // setState(() {});
        Nearby().sendBytesPayload(
          key,
          Uint8List.fromList(
            "$rideBalance|$rideDistance".codeUnits,
          ),
        );
      });
    });
  }

  // Future<dynamic> listenLocation() async {
  //   double lastDistance = 0;

  //   locationSubscription = location.onLocationChanged.handleError((onError) {
  //     locationSubscription?.cancel();
  //   }).listen((LocationData currentLocation) async {
  //     double distanceInMeters = await Geolocator.distanceBetween(
  //       lastLocation.latitude,
  //       lastLocation.longitude,
  //       currentLocation.latitude,
  //       currentLocation.longitude,
  //     );

  //     // Convertir la distance en kilomètres
  //     double distanceInKm = distanceInMeters / 1000;

  //     if (distanceInKm >= 1) {
  //       // Mettre à jour la distance parcourue
  //       rideDistance += distanceInKm;
  //       lastLocation = currentLocation;

  //       // Mettre à jour le solde et l'interface utilisateur
  //       var newBalance = basePrice * rideDistance;
  //       rideBalance = newBalance;
  //       setState(() {});
  //     }
  //   });
  // }

  Future<void> startCourse() async {
    // rideBalance = basePrice;
    await Nearby().stopAdvertising();
    customStartAdvertising();
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

  Future<dynamic> hasCourse() async {
    const basePrice = 50;
    const rideExist = true;
    const lastRideBalance = 0.0;
    if (rideExist) {
      var totalDistance = calculateDistance(0, 0, 0, 0).round();
      var newPrice = totalDistance * basePrice;
      // rideBalance = newPrice;
      customStartAdvertising();
    }
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
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          "$rideBalance",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF24292E),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Distance parcourure: $rideDistance km",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF24292E),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: MyButton(
                title: !courseStarted ? "Commencer" : "Terminer",
                color: Helper.primary,
                size: 32.0,
                width: 200.0,
                onClick: () => courseStarted ? endCourse() : startCourse(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> customStartAdvertising() async {
    try {
      bool a = await Nearby().startAdvertising(
        userName,
        strategy,
        onConnectionInitiated: onConnectionInit,
        onConnectionResult: (id, status) {
          debugPrint("Driver connected");
          streamConnected = true;
          debugPrint(status.toString());
          showSnackbar(context, "Client Connecté");
          setState(() {});
        },
        onDisconnected: (id) {
          debugPrint(
            "Driver Disconnected: ${endpointMap[id]!.endpointName}, id $id",
          );
          setState(() {
            endpointMap.remove(id);
          });
        },
      );
      debugPrint("Driver ADVERTISING: $a");
    } catch (exception) {
      debugPrint(exception.toString());
    }
  }

  void onConnectionInit(String id, ConnectionInfo info) {
    setState(() {
      endpointMap[id] = info;
    });
    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endid, payload) async {
        if (payload.type == PayloadType.BYTES) {
          String str = String.fromCharCodes(payload.bytes!);
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
        if (payloadTransferUpdate.status == PayloadStatus.IN_PROGRESS) {
          // print(payloadTransferUpdate.bytesTransferred);
        } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
          debugPrint("failed");
          // showSnackbar("$endid: FAILED to transfer file");
        } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS) {
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
  }
}
