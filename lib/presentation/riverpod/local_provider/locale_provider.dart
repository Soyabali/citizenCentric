import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/app_prefs.dart';
import '../../../app/di.dart';


final localeProvider = FutureProvider<Locale>((ref) async {
  final prefs = instance<AppPreferences>();
  final locale = await prefs.getLocal();
  return locale;
});