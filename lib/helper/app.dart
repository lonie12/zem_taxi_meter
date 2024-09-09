import "package:flutter/services.dart";
import "package:kokom/helper/helper.dart";
import "package:kokom/helper/localstorage.dart";
// import "package:shorebird_code_push/shorebird_code_push.dart";

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

    await LocalStorageManager.init();
    var permission =
        await LocalStorageManager().getEnablePermissions("permission") ?? false;
    return AppData(permission: permission);
  }
}

class AppData {
  final bool permission;

  AppData({required this.permission});
}
