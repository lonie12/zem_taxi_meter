import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:kokom/app/pages/driver/defineprice.dart';
import 'package:kokom/app/widgets/mybutton.dart';
import 'package:kokom/helper/helper.dart';
import 'package:kokom/receiver.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';

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
  var streamConnected = false;

  String? tempFileUri; //reference to the file currently being transferred
  Map<int, String> map = {}; //store filename mapped to corresponding payloadId
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? locationSubscription;

  @override
  void initState() {
    onInit();
    super.initState();
  }

  Future<void> onInit() async {
    // WakelockPlus.enable();
    location.changeSettings(
      interval: 1000,
      accuracy: loc.LocationAccuracy.high,
    );
  }

  Future<void> listenLocation() async {
    locationSubscription = location.onLocationChanged.handleError((onError) {
      locationSubscription?.cancel();
    }).listen((loc.LocationData currentlocation) async {
      // await locationChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  ElevatedButton(
                    child:
                        const Text("checkLocationPermission (<= Android 12)"),
                    onPressed: () async {
                      if (await Permission.location.isGranted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Location permissions granted :)")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Location permissions not granted :(")));
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Text("askLocationPermission"),
                    onPressed: () async {
                      if (await Permission.location.request().isGranted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Location Permission granted :)")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Location permissions not granted :(")));
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Text("checkExternalStoragePermission"),
                    onPressed: () async {
                      if (await Permission.storage.isGranted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "External Storage permissions granted :)")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "External Storage permissions not granted :(")));
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Text("askExternalStoragePermission"),
                    onPressed: () {
                      Permission.storage.request();
                    },
                  ),
                  ElevatedButton(
                    child:
                        const Text("checkBluetoothPermission (>= Android 12)"),
                    onPressed: () async {
                      if (!(await Future.wait([
                        Permission.bluetooth.isGranted,
                        Permission.bluetoothAdvertise.isGranted,
                        Permission.bluetoothConnect.isGranted,
                        Permission.bluetoothScan.isGranted,
                      ]))
                          .any((element) => false)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Bluethooth permissions granted :)")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Bluetooth permissions not granted :(")));
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Text("askBluetoothPermission (Android 12+)"),
                    onPressed: () {
                      [
                        Permission.bluetooth,
                        Permission.bluetoothAdvertise,
                        Permission.bluetoothConnect,
                        Permission.bluetoothScan
                      ].request();
                    },
                  ),
                  ElevatedButton(
                    child: const Text(
                        "checkNearbyWifiDevicesPermission (>= Android 12)"),
                    onPressed: () async {
                      if (await Permission.nearbyWifiDevices.isGranted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "NearbyWifiDevices permissions granted :)")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "NearbyWifiDevices permissions not granted :(")));
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Text(
                        "askNearbyWifiDevicesPermission (Android 12+)"),
                    onPressed: () {
                      Permission.nearbyWifiDevices.request();
                    },
                  ),
                ],
              ),
              const Divider(),
              const Text("Location Enabled"),
              Wrap(
                children: <Widget>[
                  ElevatedButton(
                    child: const Text("checkLocationEnabled"),
                    onPressed: () async {
                      if (await Location.instance.serviceEnabled()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Location is ON :)")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Location is OFF :(")));
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Text("enableLocationServices"),
                    onPressed: () async {
                      if (await Location.instance.requestService()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Location Service Enabled :)")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Enabling Location Service Failed :(")));
                      }
                    },
                  ),
                ],
              ),
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: MyButton(
                title: "Chauffeur",
                color: Helper.primary,
                size: 32.0,
                width: 200.0,
                onClick: () => Get.to(const DefinePrice()),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: MyButton(
                title: "Client",
                color: Helper.blue,
                size: 32.0,
                width: 200.0,
                onClick: () => Get.to(const KokomReceiver()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void customStartAdvertising() async {
    try {
      bool a = await Nearby().startAdvertising(
        userName,
        strategy,
        onConnectionInitiated: onConnectionInit,
        onConnectionResult: (id, status) {
          streamConnected = true;
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

  void customStartDiscovery() async {
    try {
      bool a = await Nearby().startDiscovery(
        userName,
        strategy,
        onEndpointFound: (id, name, serviceId) {
          // show sheet automatically to request connection
          print("Founded ===========");
          Future.delayed(const Duration(seconds: 3), () {
            Nearby().requestConnection(
              userName,
              id,
              onConnectionInitiated: (id, info) {
                onConnectionInit(id, info);
              },
              onConnectionResult: (id, status) {
                streamConnected = true;
                showSnackbar(status);
              },
              onDisconnected: (id) {
                setState(() {
                  endpointMap.remove(id);
                });
                showSnackbar(
                  "Disconnected from: ${endpointMap[id]!.endpointName}, id $id",
                );
              },
            );
          });
        },
        onEndpointLost: (id) {
          showSnackbar(
            "Lost discovered Endpoint: ${endpointMap[id]?.endpointName}, id $id",
          );
        },
      );
      showSnackbar("DISCOVERING: $a");
    } catch (e) {
      showSnackbar(e);
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
    setState(() {
      endpointMap[id] = info;
    });
    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endid, payload) async {
        if (payload.type == PayloadType.BYTES) {
          String str = String.fromCharCodes(payload.bytes!);
          showSnackbar("$endid: $str");

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
          showSnackbar("$endid: File transfer started");
          tempFileUri = payload.uri;
        }
      },
      onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
        if (payloadTransferUpdate.status == PayloadStatus.IN_PROGRESS) {
          print(payloadTransferUpdate.bytesTransferred);
        } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
          print("failed");
          showSnackbar("$endid: FAILED to transfer file");
        } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS) {
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
  }
}
