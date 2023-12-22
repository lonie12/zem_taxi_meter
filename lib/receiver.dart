import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kokom/app/widgets/mybutton.dart';
import 'package:kokom/helper/helper.dart';
import 'package:kokom/utils.dart';
import 'package:nearby_connections/nearby_connections.dart';
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
  var streamData = ["0", "0"];

  @override
  void initState() {
    // WakelockPlus.enable();
    super.initState();
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
                              streamData[0],
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
                          "Distance parcourure:  ${streamData[1]}km",
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
            Container(
              padding: const EdgeInsets.all(12),
              child: MyButton(
                title: "Connecter",
                color: Helper.blue,
                size: 32.0,
                width: 200.0,
                onClick: () async {
                  await Nearby().stopDiscovery();
                  customStartDiscovery();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void customStartDiscovery() async {
    try {
      bool a = await Nearby().startDiscovery(
        userName,
        strategy,
        onEndpointFound: (id, name, serviceId) {
          // show sheet automatically to request connection
          // print("Founded ===========");
          Future.delayed(const Duration(seconds: 3), () {
            Nearby().requestConnection(
              userName,
              id,
              onConnectionInitiated: (id, info) {
                onConnectionInit(id, info);
              },
              onConnectionResult: (id, status) {
                streamConnected = true;
                debugPrint(status.toString());
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

  void onConnectionInit(String id, ConnectionInfo info) {
    setState(() {
      endpointMap[id] = info;
    });
    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endid, payload) async {
        if (payload.type == PayloadType.BYTES) {
          String str = String.fromCharCodes(payload.bytes!);
          // showSnackbar(context, "str");
          streamData = [];
          streamData = str.split("|");
          setState(() {});

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
          print(payloadTransferUpdate.bytesTransferred);
        } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
          print("failed");
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
