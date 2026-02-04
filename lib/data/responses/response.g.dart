// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse(
  result: json['Result'] as String?,
  msg: json['Msg'] as String?,
);

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{'Result': instance.result, 'Msg': instance.msg};

UserDataResponse _$UserDataResponseFromJson(Map<String, dynamic> json) =>
    UserDataResponse()
      ..userId = (json['iUserId'] as num?)?.toInt()
      ..name = json['sName'] as String?
      ..contactNo = json['sContactNo'] as String?
      ..designationName = json['sDesgName'] as String?
      ..designationCode = (json['iDesgCode'] as num?)?.toInt()
      ..departmentCode = (json['iDeptCode'] as num?)?.toInt()
      ..userTypeCode = (json['iUserTypeCode'] as num?)?.toInt()
      ..token = json['sToken'] as String?
      ..lastLoginAt = json['dLastLoginAt'] as String?
      ..agencyCode = (json['iAgencyCode'] as num?)?.toInt();

Map<String, dynamic> _$UserDataResponseToJson(UserDataResponse instance) =>
    <String, dynamic>{
      'iUserId': instance.userId,
      'sName': instance.name,
      'sContactNo': instance.contactNo,
      'sDesgName': instance.designationName,
      'iDesgCode': instance.designationCode,
      'iDeptCode': instance.departmentCode,
      'iUserTypeCode': instance.userTypeCode,
      'sToken': instance.token,
      'dLastLoginAt': instance.lastLoginAt,
      'iAgencyCode': instance.agencyCode,
    };

AuthenticationResponse _$AuthenticationResponseFromJson(
  Map<String, dynamic> json,
) => AuthenticationResponse(
  result: json['Result'] as String?,
  msg: json['Msg'] as String?,
  data: (json['Data'] as List<dynamic>?)
      ?.map((e) => UserDataResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AuthenticationResponseToJson(
  AuthenticationResponse instance,
) => <String, dynamic>{
  'Result': instance.result,
  'Msg': instance.msg,
  'Data': instance.data,
};

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  userId: (json['iUserId'] as num?)?.toInt(),
  name: json['sName'] as String?,
  contactNo: json['sContactNo'] as String?,
  designationName: json['sDesgName'] as String?,
  designationCode: (json['iDesgCode'] as num?)?.toInt(),
  departmentCode: (json['iDeptCode'] as num?)?.toInt(),
  userTypeCode: (json['iUserTypeCode'] as num?)?.toInt(),
  token: json['sToken'] as String?,
  lastLoginAt: json['dLastLoginAt'] as String?,
  agencyCode: (json['iAgencyCode'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'iUserId': instance.userId,
  'sName': instance.name,
  'sContactNo': instance.contactNo,
  'sDesgName': instance.designationName,
  'iDesgCode': instance.designationCode,
  'iDeptCode': instance.departmentCode,
  'iUserTypeCode': instance.userTypeCode,
  'sToken': instance.token,
  'dLastLoginAt': instance.lastLoginAt,
  'iAgencyCode': instance.agencyCode,
};

ChangePasswordResponse _$ChangePasswordResponseFromJson(
  Map<String, dynamic> json,
) => ChangePasswordResponse(
  Result: json['Result'] as String?,
  Msg: json['Msg'] as String?,
);

Map<String, dynamic> _$ChangePasswordResponseToJson(
  ChangePasswordResponse instance,
) => <String, dynamic>{'Result': instance.Result, 'Msg': instance.Msg};

StafListResponse _$StafListResponseFromJson(Map<String, dynamic> json) =>
    StafListResponse(
      sEmpCode: json['sEmpCode'] as String?,
      sEmpName: json['sEmpName'] as String?,
      sContactNo: json['sContactNo'] as String?,
      sLocName: json['sLocName'] as String?,
      sDsgName: json['sDsgName'] as String?,
      sEmpImage: json['sEmpImage'] as String?,
    );

Map<String, dynamic> _$StafListResponseToJson(StafListResponse instance) =>
    <String, dynamic>{
      'sEmpCode': instance.sEmpCode,
      'sEmpName': instance.sEmpName,
      'sContactNo': instance.sContactNo,
      'sLocName': instance.sLocName,
      'sDsgName': instance.sDsgName,
      'sEmpImage': instance.sEmpImage,
    };
