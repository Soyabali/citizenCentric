// here we put a model every api or every response.
// we put a slider model after that we put a login model after that as a need.
import 'dart:io';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
// Model Base Response

class BaseResponse {
  final String result;
  final String msg;

  BaseResponse({
    required this.result,
    required this.msg,
  });
}

// model Dashboard
class SliderObject {
  String title;
  String subTitle;
  String image;

  SliderObject(this.title, this.subTitle, this.image);
}

class User {
  final int userId;
  final String name;
  final String contactNo;
  final String designationName;
  final int designationCode;
  final int departmentCode;
  final int userTypeCode;
  final String token;
  final String lastLoginAt;
  final int agencyCode;

  User({
    required this.userId,
    required this.name,
    required this.contactNo,
    required this.designationName,
    required this.designationCode,
    required this.departmentCode,
    required this.userTypeCode,
    required this.token,
    required this.lastLoginAt,
    required this.agencyCode,
  });
}
class Authentication {
  final int userId;
  final String name;
  final String contactNo;
  final String designationName;
  final int designationCode;
  final int departmentCode;
  final int userTypeCode;
  final String token;
  final String lastLoginAt;
  final int agencyCode;

  Authentication({
    required this.userId,
    required this.name,
    required this.contactNo,
    required this.designationName,
    required this.designationCode,
    required this.departmentCode,
    required this.userTypeCode,
    required this.token,
    required this.lastLoginAt,
    required this.agencyCode,
  });
}

// class Authentication {
//   final String result;
//   final String msg;
//   final User user;
//
//   Authentication({
//     required this.result,
//     required this.msg,
//     required this.user,
//   });
// }

// class LoginResult {
//   final BaseResponse base;
//   final Authentication user;
//
//   LoginResult({
//     required this.base,
//     required this.user,
//   });
// }

// ----------ChangePasswordModel -------------

class ChangePasswordModel {
 final String Result;
 final String Msg;

 ChangePasswordModel(
 {
   required this.Result,
   required this.Msg,

});
}

// -----------STAFFLIST MODEL------------------

class StaffListModel {
  final String sEmpCode;
  final String sEmpName;
  final String sContactNo;
  final String sLocName;
  final String sDsgName;
  final String sEmpImage;

 // constructor
  StaffListModel({
    required this.sEmpCode,
    required this.sEmpName,
    required this.sContactNo,
    required this.sLocName,
    required this.sDsgName,
    required this.sEmpImage,
});
}
// -----LocalSTORAGE DEMY MODEL

class Place {
  Place({
    required this.title,
    required this.image,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File image;
}
