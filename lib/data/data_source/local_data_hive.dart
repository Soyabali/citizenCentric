import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {

  static final loginBox = Hive.box("loginBox");
  static final registrationBox = Hive.box("registrationBox");
  static final serverBox = Hive.box("serverBox");

  // SAVE
  static Future saveLogin(Map<String, dynamic> json) async {
    await loginBox.add(json);
  }

  static Future saveRegistration(Map<String, dynamic> json) async {
    await registrationBox.add(json);
  }

  static Future saveServerForm(Map<String, dynamic> json) async {
    await serverBox.add(json);
  }

  // GET
  static List<Map<String, dynamic>> getLoginItems() {
    return loginBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static List<Map<String, dynamic>> getRegistrationItems() {
    return registrationBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static List<Map<String, dynamic>> getServerItems() {
    return serverBox.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // CLEAR
  static Future clearLogin() => loginBox.clear();
  static Future clearRegistration() => registrationBox.clear();
  static Future clearServer() => serverBox.clear();
}
