import 'package:json_annotation/json_annotation.dart';
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

//  --- Inspection List---

@JsonSerializable()
class InspectionStatusItemResponse {
  @JsonKey(name: "iTranNo")
  int? iTranNo;

  @JsonKey(name: "iParkId")
  int? iParkId;

  @JsonKey(name: "sParkName")
  String? sParkName;

  @JsonKey(name: "sSectorName")
  String? sSectorName;

  @JsonKey(name: "sDevisionName")
  String? sDevisionName;

  @JsonKey(name: "sReportType")
  String? sReportType;

  @JsonKey(name: "fPaneltyCharges")
  double? fPaneltyCharges;

  @JsonKey(name: "sDescription")
  String? sDescription;

  @JsonKey(name: "fLatitude")
  double? fLatitude;

  @JsonKey(name: "fLongitude")
  double? fLongitude;

  @JsonKey(name: "sGoogleLocation")
  String? sGoogleLocation;

  @JsonKey(name: "sPhoto")
  String? sPhoto;

  @JsonKey(name: "sAgencyName")
  String? sAgencyName;

  @JsonKey(name: "sInspBy")
  String? sInspBy;

  @JsonKey(name: "dInspAt")
  String? dInspAt;

  @JsonKey(name: "sStatus")
  String? sStatus;

  InspectionStatusItemResponse({
    this.iTranNo,
    this.iParkId,
    this.sParkName,
    this.sSectorName,
    this.sDevisionName,
    this.sReportType,
    this.fPaneltyCharges,
    this.sDescription,
    this.fLatitude,
    this.fLongitude,
    this.sGoogleLocation,
    this.sPhoto,
    this.sAgencyName,
    this.sInspBy,
    this.dInspAt,
    this.sStatus,
  });

  factory InspectionStatusItemResponse.fromJson(
      Map<String, dynamic> json) =>
      _$InspectionStatusItemResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InspectionStatusItemResponseToJson(this);
}
// inspectionList response

@JsonSerializable()
class InspectionStatusListResponse {
  @JsonKey(name: "Result")
  String? result;

  @JsonKey(name: "Msg")
  String? msg;

  @JsonKey(name: "Data")
  List<InspectionStatusItemResponse>? data;

  InspectionStatusListResponse({
    this.result,
    this.msg,
    this.data,
  });

  factory InspectionStatusListResponse.fromJson(
      Map<String, dynamic> json) =>
      _$InspectionStatusListResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InspectionStatusListResponseToJson(this);
}
//  --- CountDashboard response

@JsonSerializable()
class CountDashboardItemResponse {
  @JsonKey(name: "iTotalParks")
  int? iTotalParks;

  @JsonKey(name: "iTotalGeotagged")
  int? iTotalGeotagged;

  @JsonKey(name: "iTotalInspection")
  int? iTotalInspection;

  @JsonKey(name: "iTotalInspectionAmt")
  int? iTotalInspectionAmt;

  @JsonKey(name: "TotalResolvedInspection")
  int? totalResolvedInspection;

  @JsonKey(name: "iTotalReceviedAmt")
  int? iTotalReceviedAmt;

  CountDashboardItemResponse({
    this.iTotalParks,
    this.iTotalGeotagged,
    this.iTotalInspection,
    this.iTotalInspectionAmt,
    this.totalResolvedInspection,
    this.iTotalReceviedAmt,
  });

  factory CountDashboardItemResponse.fromJson(Map<String, dynamic> json) =>
      _$CountDashboardItemResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CountDashboardItemResponseToJson(this);
}

//

@JsonSerializable()
class CountDashboardListResponse {
  @JsonKey(name: "Result")
  String? result;

  @JsonKey(name: "Msg")
  String? msg;

  @JsonKey(name: "Data")

  List<CountDashboardItemResponse>? data;

  CountDashboardListResponse({
    this.result,
    this.msg,
    this.data,
  });

  factory CountDashboardListResponse.fromJson(Map<String, dynamic> json) =>
      _$CountDashboardListResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CountDashboardListResponseToJson(this);
}
//  xxxx------ ParkListByAgency  -----xxxxxx.

@JsonSerializable()
class ParkListByAgencyItemResponse {

  @JsonKey(name: "iParkId")
  int? iParkId;

  @JsonKey(name: "sParkName")
  String? sParkName;

  @JsonKey(name: "iNoOfWorkers")
  int? iNoOfWorkers;

  @JsonKey(name: "sSupervisor")
  String? sSupervisor;

  @JsonKey(name: "sAssetDirector")
  String? sAssetDirector;

  @JsonKey(name: "sDuptyDirector")
  String? sDuptyDirector;

  @JsonKey(name: "sDirector")
  String? sDirector;

  @JsonKey(name: "sAgencyName")
  String? sAgencyName;

  @JsonKey(name: "iAgencyCode")
  int? iAgencyCode;

  @JsonKey(name: "fArea")
  String? fArea;

  @JsonKey(name: "fLatitude")
  double? fLatitude;

  @JsonKey(name: "fLongitude")
  double? fLongitude;

  @JsonKey(name: "sGoogleLocation")
  String? sGoogleLocation;

  @JsonKey(name: "sParkPhoto")
  String? sParkPhoto;

  ParkListByAgencyItemResponse({
    this.iParkId,
    this.sParkName,
    this.iNoOfWorkers,
    this.sSupervisor,
    this.sAssetDirector,
    this.sDuptyDirector,
    this.sDirector,
    this.sAgencyName,
    this.iAgencyCode,
    this.fArea,
    this.fLatitude,
    this.fLongitude,
    this.sGoogleLocation,
    this.sParkPhoto,
  });

  factory ParkListByAgencyItemResponse.fromJson(Map<String, dynamic> json) =>
      _$ParkListByAgencyItemResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ParkListByAgencyItemResponseToJson(this);
}


@JsonSerializable()
class ParkListByAgencyItemResponseDetail {
  @JsonKey(name: "Result")
  String? result;
  @JsonKey(name: "Msg")
  String? msg;
  @JsonKey(name: "Data")

  List<ParkListByAgencyItemResponse>? data;

  ParkListByAgencyItemResponseDetail({
    this.result,
    this.msg,
    this.data,
  });

  factory ParkListByAgencyItemResponseDetail.fromJson(Map<String, dynamic> json) =>
      _$ParkListByAgencyItemResponseDetailFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ParkListByAgencyItemResponseDetailToJson(this);
}
