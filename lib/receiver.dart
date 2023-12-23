import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kokom/app/widgets/mybutton.dart';
import 'package:kokom/helper/helper.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';

class KokomReceiver extends StatefulWidget {
  const KokomReceiver({super.key});

  @override
  State<KokomReceiver> createState() => _KokomReceiverState();
}

class _KokomReceiverState extends State<KokomReceiver> {
  final String userName = Random().nextInt(10000).toString();
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, ConnectionInfo> endpointMap = {};
  var streamConnected = false;
  var streamData = ["", ""];

  @override
  void initState() {
    WakelockPlus.enable();
    super.initState();
  }

  @override
  void dispose() {
    Nearby().stopDiscovery();
    super.dispose();
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
                    // await endCourse();
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
                    children: [
                      streamConnected
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 12,
                                  width: 12,
                                  decoration:
                                      const BoxDecoration(color: Colors.green),
                                ),
                                const SizedBox(width: 6),
                                const Text("Connecté")
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(height: 12),
                      Column(
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
                                "$streamData[0]",
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
                            "Distance parcourure: $streamData[1] km",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF24292E),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              !streamConnected
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      child: MyButton(
                        title: "Connecter",
                        color: Helper.blue,
                        size: 32.0,
                        width: 200.0,
                        onClick: () async {
                          await Nearby().stopAdvertising();
                          customStartAdvertising();
                        },
                      ),
                    )
                  : const SizedBox()
            ],
          ),
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
          streamConnected = true;
          debugPrint(status.toString());
          setState(() {});
        },
        onDisconnected: (id) {
          debugPrint(
            "Client Disconnected: ${endpointMap[id]!.endpointName}, id $id",
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
          streamData = [];
          streamData = str.split("|");
          setState(() {});
        } else if (payload.type == PayloadType.FILE) {}
      },
      onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
        if (payloadTransferUpdate.status == PayloadStatus.IN_PROGRESS) {
          debugPrint(payloadTransferUpdate.bytesTransferred.toString());
        } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
          debugPrint("failed");
        } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS) {}
      },
    );
  }
}
