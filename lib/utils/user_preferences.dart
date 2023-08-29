import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserPreferences {
  static Future<void> storeValue(String key, String value) async {
    const storage = FlutterSecureStorage();

    await storage.write(key: key, value: value);

    log('storeValue and the $key is  $value');
  }

  static Future<String?> retrieveValue(String key) async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: key);
    log('retrieveValue and the $key is $value ');

    return value;
  }

  static Future<void> deleteValue(String key) async {
    const storage = FlutterSecureStorage();

    await storage.delete(key: key);
  }

  static Future<void> clearStorage() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
  }

  static Future<bool> checkIfValueExist(String key) async {
    const storage = FlutterSecureStorage();
    return storage.containsKey(key: key);
  }
}
