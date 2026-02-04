import 'package:json_annotation/json_annotation.dart';
import '../../domain/model/model.dart';
part 'response.g.dart'; // Required for json_serializable

//   ------BaseResponse---------.

@JsonSerializable()

class BaseResponse {
  @JsonKey(name: "Result")
  String? result;

  @JsonKey(name: "Msg")
  String? msg;

  BaseResponse({this.result, this.msg});

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}


//----------UserDataResponse-------------.

@JsonSerializable()
class UserDataResponse {
  @JsonKey(name: "iUserId")
  int? userId;

  @JsonKey(name: "sName")
  String? name;

  @JsonKey(name: "sContactNo")
  String? contactNo;

  @JsonKey(name: "sDesgName")
  String? designationName;

  @JsonKey(name: "iDesgCode")
  int? designationCode;

  @JsonKey(name: "iDeptCode")
  int? departmentCode;

  @JsonKey(name: "iUserTypeCode")
  int? userTypeCode;

  @JsonKey(name: "sToken")
  String? token;

  @JsonKey(name: "dLastLoginAt")
  String? lastLoginAt;

  @JsonKey(name: "iAgencyCode")
  int? agencyCode;

  UserDataResponse();

  factory UserDataResponse.fromJson(Map<String, dynamic> json) =>
      _$UserDataResponseFromJson(json);
}


@JsonSerializable()
class AuthenticationResponse extends BaseResponse {
  @JsonKey(name: "Data")
  List<UserDataResponse>? data;

  AuthenticationResponse({
    String? result,
    String? msg,
    this.data,
  }) : super(result: result, msg: msg);

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);
}

// userData----.

@JsonSerializable()
class UserData {
  @JsonKey(name: "iUserId")
  int? userId;

  @JsonKey(name: "sName")
  String? name;

  @JsonKey(name: "sContactNo")
  String? contactNo;

  @JsonKey(name: "sDesgName")
  String? designationName;

  @JsonKey(name: "iDesgCode")
  int? designationCode;

  @JsonKey(name: "iDeptCode")
  int? departmentCode;

  @JsonKey(name: "iUserTypeCode")
  int? userTypeCode;

  @JsonKey(name: "sToken")
  String? token;

  @JsonKey(name: "dLastLoginAt")
  String? lastLoginAt;

  @JsonKey(name: "iAgencyCode")
  int? agencyCode;

  UserData({
    this.userId,
    this.name,
    this.contactNo,
    this.designationName,
    this.designationCode,
    this.departmentCode,
    this.userTypeCode,
    this.token,
    this.lastLoginAt,
    this.agencyCode,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

 //  ---ChangePasswordResponse----.

@JsonSerializable()
class ChangePasswordResponse {
  @JsonKey(name: "Result")
  String? Result;
  @JsonKey(name: "Msg")
  String? Msg;

  ChangePasswordResponse({
   this.Result,
   this.Msg
});
   // Fromjson
  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordResponseFromJson(json);
  // Tojson
  Map<String, dynamic> toJson() => _$ChangePasswordResponseToJson(this);
}
//------StaffListResponse-----
@JsonSerializable()
class StafListResponse {
  @JsonKey(name: "sEmpCode")
  String? sEmpCode;
  @JsonKey(name: "sEmpName")
  String? sEmpName;
  @JsonKey(name: "sContactNo")
  String? sContactNo;
  @JsonKey(name: "sLocName")
  String? sLocName;
  @JsonKey(name: "sDsgName")
  String? sDsgName;
  @JsonKey(name: "sEmpImage")
  String? sEmpImage;

  StafListResponse({
    this.sEmpCode,
    this.sEmpName,
    this.sContactNo,
    this.sLocName,
    this.sDsgName,
    this.sEmpImage,
  });
  // Fromjson
  factory StafListResponse.fromJson(Map<String, dynamic> json) =>
      _$StafListResponseFromJson(json);
  // Tojson
  Map<String, dynamic> toJson() => _$StafListResponseToJson(this);
}