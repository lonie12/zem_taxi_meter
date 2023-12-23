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
    Nearby().stopAdvertising();
    Nearby().stopAllEndpoints();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                streamConnected
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 12, left: 12),
                          child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: Helper.success,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Connecté",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontSize: 18,
                                        color: Helper.primary,
                                        fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () async {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
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
              ],
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
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
                                  streamData.first,
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
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF24292E),
                                  ),
                        ),
                        Text(
                          "${streamData.last} km",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF24292E),
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Helper.warning),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 11, horizontal: 15),
                  ),
                ),
                onPressed: () async {
                  await Nearby().stopAllEndpoints();
                  await Nearby().stopAdvertising();
                  customStartAdvertising();
                },
                child: Text(
                  "Connecter",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white, fontSize: 16),
                ),
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
      debugPrint("Client ADVERTISING: $a");
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
