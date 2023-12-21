import 'dart:math';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearby_connections/nearby_connections.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Connections example app'),
        ),
        body: const Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<Body> {
  final String userName = Random().nextInt(10000).toString();
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, ConnectionInfo> endpointMap = {};

  String? tempFileUri; //reference to the file currently being transferred
  Map<int, String> map = {}; //store filename mapped to corresponding payloadId

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              const Divider(),
              Text("User Name: $userName"),
              Wrap(
                children: <Widget>[
                  ElevatedButton(
                    child: const Text("Start Advertising"),
                    onPressed: () async {
                      try {
                        bool a = await Nearby().startAdvertising(
                          userName,
                          strategy,
                          onConnectionInitiated: onConnectionInit,
                          onConnectionResult: (id, status) {
                            showSnackbar(status);
                          },
                          onDisconnected: (id) {
                            showSnackbar(
                                "Disconnected: ${endpointMap[id]!.endpointName}, id $id");
                            setState(() {
                              endpointMap.remove(id);
                            });
                          },
                        );
                        showSnackbar("ADVERTISING: $a");
                      } catch (exception) {
                        showSnackbar(exception);
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Text("Stop Advertising"),
                    onPressed: () async {
                      await Nearby().stopAdvertising();
                    },
                  ),
                ],
              ),
              Wrap(
                children: <Widget>[
                  ElevatedButton(
                    child: const Text("Start Discovery"),
                    onPressed: () async {
                      try {
                        bool a = await Nearby().startDiscovery(
                          userName,
                          strategy,
                          onEndpointFound: (id, name, serviceId) {
                            // show sheet automatically to request connection
                            showModalBottomSheet(
                              context: context,
                              builder: (builder) {
                                return Center(
                                  child: Column(
                                    children: <Widget>[
                                      Text("id: $id"),
                                      Text("Name: $name"),
                                      Text("ServiceId: $serviceId"),
                                      ElevatedButton(
                                        child: const Text("Request Connection"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Nearby().requestConnection(
                                            userName,
                                            id,
                                            onConnectionInitiated: (id, info) {
                                              onConnectionInit(id, info);
                                            },
                                            onConnectionResult: (id, status) {
                                              showSnackbar(status);
                                            },
                                            onDisconnected: (id) {
                                              setState(() {
                                                endpointMap.remove(id);
                                              });
                                              showSnackbar(
                                                  "Disconnected from: ${endpointMap[id]!.endpointName}, id $id");
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          onEndpointLost: (id) {
                            showSnackbar(
                                "Lost discovered Endpoint: ${endpointMap[id]?.endpointName}, id $id");
                          },
                        );
                        showSnackbar("DISCOVERING: $a");
                      } catch (e) {
                        showSnackbar(e);
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Text("Stop Discovery"),
                    onPressed: () async {
                      await Nearby().stopDiscovery();
                    },
                  ),
                ],
              ),
              Text("Number of connected devices: ${endpointMap.length}"),
              ElevatedButton(
                child: const Text("Stop All Endpoints"),
                onPressed: () async {
                  await Nearby().stopAllEndpoints();
                  setState(() {
                    endpointMap.clear();
                  });
                },
              ),
              const Divider(),
              const Text(
                "Sending Data",
              ),
              ElevatedButton(
                child: const Text("Send Random Bytes Payload"),
                onPressed: () async {
                  endpointMap.forEach((key, value) {
                    String a = Random().nextInt(100).toString();

                    showSnackbar(
                        "Sending $a to ${value.endpointName}, id: $key");
                    Nearby()
                        .sendBytesPayload(key, Uint8List.fromList(a.codeUnits));
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => customStart(),
              child: Text("Commencer"),
            ),
            SizedBox(height: 12),
            
            ElevatedButton(
              onPressed: () {},
              child: Text("Suivre"),
            ),
          ],
        ),
      ),
    );
  }

  void customStart() async {
    try {
      bool a = await Nearby().startAdvertising(
        userName,
        strategy,
        onConnectionInitiated: onConnectionInit,
        onConnectionResult: (id, status) {
          showSnackbar(status);
        },
        onDisconnected: (id) {
          showSnackbar(
              "Disconnected: ${endpointMap[id]!.endpointName}, id $id");
          setState(() {
            endpointMap.remove(id);
          });
        },
      );
      showSnackbar("ADVERTISING: $a");
    } catch (exception) {
      showSnackbar(exception);
    }
  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  Future<bool> moveFile(String uri, String fileName) async {
    String parentDir = (await getExternalStorageDirectory())!.absolute.path;
    final b =
        await Nearby().copyFileAndDeleteOriginal(uri, '$parentDir/$fileName');

    showSnackbar("Moved file:$b");
    return b;
  }

  /// Called upon Connection request (on both devices)
  /// Both need to accept connection to start sending/receiving
  void onConnectionInit(String id, ConnectionInfo info) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Center(
          child: Column(
            children: <Widget>[
              Text("id: $id"),
              Text("Token: ${info.authenticationToken}"),
              Text("Name${info.endpointName}"),
              Text("Incoming: ${info.isIncomingConnection}"),
              ElevatedButton(
                child: const Text("Accept Connection"),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    endpointMap[id] = info;
                  });
                  Nearby().acceptConnection(
                    id,
                    onPayLoadRecieved: (endid, payload) async {
                      if (payload.type == PayloadType.BYTES) {
                        String str = String.fromCharCodes(payload.bytes!);
                        showSnackbar("$endid: $str");

                        if (str.contains(':')) {
                          // used for file payload as file payload is mapped as
                          // payloadId:filename
                          int payloadId = int.parse(str.split(':')[0]);
                          String fileName = (str.split(':')[1]);

                          if (map.containsKey(payloadId)) {
                            if (tempFileUri != null) {
                              moveFile(tempFileUri!, fileName);
                            } else {
                              showSnackbar("File doesn't exist");
                            }
                          } else {
                            //add to map if not already
                            map[payloadId] = fileName;
                          }
                        }
                      } else if (payload.type == PayloadType.FILE) {
                        showSnackbar("$endid: File transfer started");
                        tempFileUri = payload.uri;
                      }
                    },
                    onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                      if (payloadTransferUpdate.status ==
                          PayloadStatus.IN_PROGRESS) {
                        print(payloadTransferUpdate.bytesTransferred);
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.FAILURE) {
                        print("failed");
                        showSnackbar("$endid: FAILED to transfer file");
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.SUCCESS) {
                        showSnackbar(
                            "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");

                        if (map.containsKey(payloadTransferUpdate.id)) {
                          //rename the file now
                          String name = map[payloadTransferUpdate.id]!;
                          moveFile(tempFileUri!, name);
                        } else {
                          //bytes not received till yet
                          map[payloadTransferUpdate.id] = "";
                        }
                      }
                    },
                  );
                },
              ),
              ElevatedButton(
                child: const Text("Reject Connection"),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await Nearby().rejectConnection(id);
                  } catch (e) {
                    showSnackbar(e);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
