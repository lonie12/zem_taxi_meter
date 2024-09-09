import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageManager {
  static late SharedPreferences localstorage;
  static init() async {
    localstorage = await SharedPreferences.getInstance();
  }

  Future<void> saveEnablePermissions(String key, bool value) async {
    await localstorage.setString(key, value.toString());
  }

  Future<bool?> getEnablePermissions(String key) async {
    var isEnabled = localstorage.getString(key) ?? "";
    return isEnabled.toLowerCase() == "true";
  }

  Future<void> savePrices(basePrice, kmPrice) async {
    final Map<String, dynamic> data = {
      'basePrice': basePrice,
      'kmPrice': kmPrice,
    };
    var store = json.encode(data);
    await localstorage.setString('my_prices', store);
  }

  Future<void> getPrices() async {
    final dynamic savedData = localstorage.getString('my_prices') ?? "[]";
    var data = json.decode(savedData);
    // final dynamic savedData = storage.getItem('my_data');
    if (data != null) {
      data['basePrice'].toString();
      data['kmPrice'].toString();
    }
  }
}
