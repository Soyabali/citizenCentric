import 'dart:convert';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import '../presentation/resources/language_manager.dart';

const String PREFS_KEY_LANG = "PREFS_KEY_LANG";
const String PREFS_KEY_ONBOARDING_SCREEN = "PREFS_KEY_ONBOARDING_SCREEN";
const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";
const String PREFS_KEY_IS_USER_CHANGE_PASSWORD_IN = "PREFS_KEY_IS_USER_CHANGE_PASSWORD_IN";
const String PREFS_KEY_TOKEN = "PREFS_KEY_TOKEN";
const String PREFS_KEY_LOGIN_DATA = "PREFS_KEY_LOGIN_DATA";


class AppPreferences {

 final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);

    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.ENGLISH.getValue();
    }
  }
  Future<void> setLanguageChanged() async {
   String currentLanguage = await getAppLanguage();
   if(currentLanguage == LanguageType.ARABIC.getValue()){
     // save prefs with english lang
     _sharedPreferences.setString(PREFS_KEY_LANG, LanguageType.ENGLISH.getValue());
   }else{
     // save prefs with arabic lang
     _sharedPreferences.setString(PREFS_KEY_LANG, LanguageType.ARABIC.getValue());
   }
  }

  Future<Locale> getLocal() async {
    String currentLanguage = await getAppLanguage();
    if (currentLanguage == LanguageType.ARABIC.getValue()) {
      // return arabic local
      return ARABIC_LOCAL;
    } else {
      // return english local
      return ENGLISH_LOCAL;
    }
  }

  Future<void> logout() async {
    _sharedPreferences.remove(PREFS_KEY_IS_USER_LOGGED_IN);
  }

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN, true);
  }

  Future<void> setUserToken(String token) async {
    _sharedPreferences.setString(PREFS_KEY_TOKEN, token);
  }

  Future<String> getUserToken() async {
    return _sharedPreferences.getString(PREFS_KEY_TOKEN) ?? "TOKEN NOT SAVED";
  }
  // to store loginData

  Future<void> setLoginUserData({
    required int userId,
    required String name,
    required String contactNo,
    required String designationName,
    required int designationCode,
    required int departmentCode,
    required int userTypeCode,
    required String lastLoginAt,
    required int agencyCode,
  }) async {
    final Map<String, dynamic> loginData = {
      "userId": userId,
      "name": name,
      "contactNo": contactNo,
      "designationName": designationName,
      "designationCode": designationCode,
      "departmentCode": departmentCode,
      "userTypeCode": userTypeCode,
      "lastLoginAt": lastLoginAt,
      "agencyCode": agencyCode,
    };

    await _sharedPreferences.setString(
      PREFS_KEY_LOGIN_DATA,
      jsonEncode(loginData),
    );
  }
  // to read login data

  Future<Map<String, dynamic>?> getLoginUserData() async {
    final jsonString =
    _sharedPreferences.getString(PREFS_KEY_LOGIN_DATA);

    if (jsonString == null) return null;

    return jsonDecode(jsonString) as Map<String, dynamic>;
  }



  Future<bool> isOnBoardingScreenViewed() async {return _sharedPreferences.getBool(PREFS_KEY_ONBOARDING_SCREEN) ?? false;
  }

  Future<void> setIsUserLoggedIn() async {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  // changePassword
  Future<void> setIsUserChangePassword() async {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_CHANGE_PASSWORD_IN, true);
  }

  Future<bool> isUserChangePassword() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_CHANGE_PASSWORD_IN) ?? false;
  }
}
