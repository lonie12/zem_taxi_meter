
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

  // // Enregistrer localement les informations d'un utilisateur
  // static saveUserInformations(User user) async {
  //   token = user.token;
  //   dtoken = user.devicetoken ?? "";
  //   var encoded = json.encode(user);
  //   await localstorage.setString("userData", encoded);
  //   await LocalStorage.init();
  //   return user = user;
  // }

  // User account to local
  // static saveUserAccount(Account data) async {
  //   var encoded = json.encode(data);
  //   await localstorage.setString("userAccount", encoded);
  //   await LocalStorage.init();
  //   return account = data;
  // }



  // User just install the app
  static isFirstUse() async {
    firstUse = true;
    await LocalStorage.init();
  }

  // User just install the app
  static isKokomFirstSeeing() async {
    kokomFistSeeing = true;
    await LocalStorage.init();
  }

  //
  static thisNotKokomFirstSeeing() async {
    kokomFistSeeing = false;
    await LocalStorage.init();
  }

  //
  static thisNotFirstUse() async {
    firstUse = false;
    await LocalStorage.init();
  }

  // static getUserLocalInformations() {
  //   var data = localstorage.getString("userData") ?? "[]";
  //   var decode = json.decode(data);
  //   return user = User.fromJson(decode);
  // }

  // // Enregistrer la commande de véhicule en cours
  // static saveCurrentOrder(Ride order) async {
  //   var encoded = json.encode(order);
  //   await localstorage.setString("vOrdered", encoded);
  //   await LocalStorage.init();
  // }

  // Récuperer la commande de véhicule enregistrer précedemment
  // static Future<Ride> getCurrentOrder() async {
  //   var data = localstorage.getString("vOrdered") ?? "[]";
  //   var decode = json.decode(data);
  //   return currentVehicleOrdered = Ride.fromJson(decode);
  // }



  // static Future setUserBet(userBet) async {
  //   bet = userBet;
  //   return await LocalStorage.init();
  // }

  // userIsLogged
  // static userIsLogged() async {
  //   logged = true;
  //   return await LocalStorage.init();
  // }






}
