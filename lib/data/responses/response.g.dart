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

InspectionStatusItemResponse _$InspectionStatusItemResponseFromJson(
  Map<String, dynamic> json,
) => InspectionStatusItemResponse(
  iTranNo: (json['iTranNo'] as num?)?.toInt(),
  iParkId: (json['iParkId'] as num?)?.toInt(),
  sParkName: json['sParkName'] as String?,
  sSectorName: json['sSectorName'] as String?,
  sDevisionName: json['sDevisionName'] as String?,
  sReportType: json['sReportType'] as String?,
  fPaneltyCharges: (json['fPaneltyCharges'] as num?)?.toDouble(),
  sDescription: json['sDescription'] as String?,
  fLatitude: (json['fLatitude'] as num?)?.toDouble(),
  fLongitude: (json['fLongitude'] as num?)?.toDouble(),
  sGoogleLocation: json['sGoogleLocation'] as String?,
  sPhoto: json['sPhoto'] as String?,
  sAgencyName: json['sAgencyName'] as String?,
  sInspBy: json['sInspBy'] as String?,
  dInspAt: json['dInspAt'] as String?,
  sStatus: json['sStatus'] as String?,
);

Map<String, dynamic> _$InspectionStatusItemResponseToJson(
  InspectionStatusItemResponse instance,
) => <String, dynamic>{
  'iTranNo': instance.iTranNo,
  'iParkId': instance.iParkId,
  'sParkName': instance.sParkName,
  'sSectorName': instance.sSectorName,
  'sDevisionName': instance.sDevisionName,
  'sReportType': instance.sReportType,
  'fPaneltyCharges': instance.fPaneltyCharges,
  'sDescription': instance.sDescription,
  'fLatitude': instance.fLatitude,
  'fLongitude': instance.fLongitude,
  'sGoogleLocation': instance.sGoogleLocation,
  'sPhoto': instance.sPhoto,
  'sAgencyName': instance.sAgencyName,
  'sInspBy': instance.sInspBy,
  'dInspAt': instance.dInspAt,
  'sStatus': instance.sStatus,
};

InspectionStatusListResponse _$InspectionStatusListResponseFromJson(
  Map<String, dynamic> json,
) => InspectionStatusListResponse(
  result: json['Result'] as String?,
  msg: json['Msg'] as String?,
  data: (json['Data'] as List<dynamic>?)
      ?.map(
        (e) => InspectionStatusItemResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$InspectionStatusListResponseToJson(
  InspectionStatusListResponse instance,
) => <String, dynamic>{
  'Result': instance.result,
  'Msg': instance.msg,
  'Data': instance.data,
};

CountDashboardItemResponse _$CountDashboardItemResponseFromJson(
  Map<String, dynamic> json,
) => CountDashboardItemResponse(
  iTotalParks: (json['iTotalParks'] as num?)?.toInt(),
  iTotalGeotagged: (json['iTotalGeotagged'] as num?)?.toInt(),
  iTotalInspection: (json['iTotalInspection'] as num?)?.toInt(),
  iTotalInspectionAmt: (json['iTotalInspectionAmt'] as num?)?.toInt(),
  totalResolvedInspection: (json['TotalResolvedInspection'] as num?)?.toInt(),
  iTotalReceviedAmt: (json['iTotalReceviedAmt'] as num?)?.toInt(),
);

Map<String, dynamic> _$CountDashboardItemResponseToJson(
  CountDashboardItemResponse instance,
) => <String, dynamic>{
  'iTotalParks': instance.iTotalParks,
  'iTotalGeotagged': instance.iTotalGeotagged,
  'iTotalInspection': instance.iTotalInspection,
  'iTotalInspectionAmt': instance.iTotalInspectionAmt,
  'TotalResolvedInspection': instance.totalResolvedInspection,
  'iTotalReceviedAmt': instance.iTotalReceviedAmt,
};

CountDashboardListResponse _$CountDashboardListResponseFromJson(
  Map<String, dynamic> json,
) => CountDashboardListResponse(
  result: json['Result'] as String?,
  msg: json['Msg'] as String?,
  data: (json['Data'] as List<dynamic>?)
      ?.map(
        (e) => CountDashboardItemResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$CountDashboardListResponseToJson(
  CountDashboardListResponse instance,
) => <String, dynamic>{
  'Result': instance.result,
  'Msg': instance.msg,
  'Data': instance.data,
};

ParkListByAgencyItemResponse _$ParkListByAgencyItemResponseFromJson(
  Map<String, dynamic> json,
) => ParkListByAgencyItemResponse(
  iParkId: (json['iParkId'] as num?)?.toInt(),
  sParkName: json['sParkName'] as String?,
  iNoOfWorkers: (json['iNoOfWorkers'] as num?)?.toInt(),
  sSupervisor: json['sSupervisor'] as String?,
  sAssetDirector: json['sAssetDirector'] as String?,
  sDuptyDirector: json['sDuptyDirector'] as String?,
  sDirector: json['sDirector'] as String?,
  sAgencyName: json['sAgencyName'] as String?,
  iAgencyCode: (json['iAgencyCode'] as num?)?.toInt(),
  fArea: json['fArea'] as String?,
  fLatitude: (json['fLatitude'] as num?)?.toDouble(),
  fLongitude: (json['fLongitude'] as num?)?.toDouble(),
  sGoogleLocation: json['sGoogleLocation'] as String?,
  sParkPhoto: json['sParkPhoto'] as String?,
);

Map<String, dynamic> _$ParkListByAgencyItemResponseToJson(
  ParkListByAgencyItemResponse instance,
) => <String, dynamic>{
  'iParkId': instance.iParkId,
  'sParkName': instance.sParkName,
  'iNoOfWorkers': instance.iNoOfWorkers,
  'sSupervisor': instance.sSupervisor,
  'sAssetDirector': instance.sAssetDirector,
  'sDuptyDirector': instance.sDuptyDirector,
  'sDirector': instance.sDirector,
  'sAgencyName': instance.sAgencyName,
  'iAgencyCode': instance.iAgencyCode,
  'fArea': instance.fArea,
  'fLatitude': instance.fLatitude,
  'fLongitude': instance.fLongitude,
  'sGoogleLocation': instance.sGoogleLocation,
  'sParkPhoto': instance.sParkPhoto,
};

ParkListByAgencyItemResponseDetail _$ParkListByAgencyItemResponseDetailFromJson(
  Map<String, dynamic> json,
) => ParkListByAgencyItemResponseDetail(
  result: json['Result'] as String?,
  msg: json['Msg'] as String?,
  data: (json['Data'] as List<dynamic>?)
      ?.map(
        (e) => ParkListByAgencyItemResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$ParkListByAgencyItemResponseDetailToJson(
  ParkListByAgencyItemResponseDetail instance,
) => <String, dynamic>{
  'Result': instance.result,
  'Msg': instance.msg,
  'Data': instance.data,
};
