import "package:flutter/services.dart";
import "package:kokom/helper/helper.dart";
import "package:kokom/helper/localstorage.dart";

class App {
  App._();

  static Future<AppData> initialize() async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Helper.primary,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    LocalStorageManager localStorageManager = LocalStorageManager();
    bool? permission =
        await localStorageManager.getEnablePermissions('permission') ?? false;

    return AppData(permission: permission);
  }
}

class AppData {
  final bool permission;

  AppData({required this.permission});
}
