import 'package:localstorage/localstorage.dart';

class LocalStorageManager {
  final LocalStorage storage = LocalStorage('my_app');

  Future<void> saveEnablePermissions(String key, bool value) async {
    await storage.ready;
    storage.setItem(key, value);
  }

  Future<bool?> getEnablePermissions(String key) async {
    await storage.ready;
    return storage.getItem(key);
  }

  Future<void> savePrices(basePrice, kmPrice) async {
    final Map<String, dynamic> data = {
      'basePrice': basePrice,
      'kmPrice': kmPrice,
    };
    storage.setItem('my_prices', data);
  }

  Future<void> getPrices() async {
    final dynamic savedData = storage.getItem('my_data');
    if (savedData != null) {
      savedData['basePrice'].toString();
      savedData['kmPrice'].toString();
    }
  }
}
