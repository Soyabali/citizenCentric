
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('myBox');
  }

  static Box get myBox => Hive.box('myBox');
}