import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // static final profileProvider = Get.put(ProfileController());
  static late SharedPreferences localstorage;
  static init() async {
    localstorage = await SharedPreferences.getInstance();
  }

  // Token (device token)
  static String get dtoken => localstorage.getString("deviceToken") ?? "";
  static set dtoken(String token) =>
      localstorage.setString("deviceToken", token);

  // Mise de l'utilisateur (bet)
  static int get bet => localstorage.getInt("bet") ?? 0;
  static set bet(int uBet) => localstorage.setInt("bet", uBet);

  // Commandes en cours

  // Token d'identification (api)
  static String get token => localstorage.getString("userToken") ?? "";
  static set token(String token) => localstorage.setString("userToken", token);

  // Version de l'application
  static String get appversion => localstorage.getString("appversion") ?? "";
  static set appversion(String version) =>
      localstorage.setString("appversion", version);

  //
  static bool get isdark => localstorage.getBool("isdark") ?? false;

  // Première connection à l'application
  static bool get firstUse => localstorage.getBool("firstUse") ?? true;
  static set firstUse(bool value) => localstorage.setBool("firstUse", value);

  // Première connection à l'application
  static bool get isSponsor => localstorage.getBool("isSponsor") ?? false;
  static set isSponsor(bool value) => localstorage.setBool("isSponsor", value);

  // First kokom entered
  static bool get kokomFistSeeing =>
      localstorage.getBool("kokomFirstSeeing") ?? true;
  static set kokomFistSeeing(bool value) =>
      localstorage.setBool("kokomFirstSeeing", value);

}
