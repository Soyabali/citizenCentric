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

//------Inspection List Model---

class InspectionStatusModel {
  final int tranNo;
  final int parkId;
  final String parkName;
  final String sectorName;
  final String divisionName;
  final String reportType;
  final double penaltyCharges;
  final String description;
  final double latitude;
  final double longitude;
  final String googleLocation;
  final String photoUrl;
  final String agencyName;
  final String inspectedBy;
  final String inspectedAt;
  final String status;

  // constructor
  InspectionStatusModel({
    required this.tranNo,
    required this.parkId,
    required this.parkName,
    required this.sectorName,
    required this.divisionName,
    required this.reportType,
    required this.penaltyCharges,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.googleLocation,
    required this.photoUrl,
    required this.agencyName,
    required this.inspectedBy,
    required this.inspectedAt,
    required this.status,
  });
}

// ----CountDashBoard-----.

class CountDashboardModel {
  final int iTotalParks;
  final int iTotalGeotagged;
  final int iTotalInspection;
  final int iTotalInspectionAmt;
  final int totalResolvedInspection;
  final int iTotalReceviedAmt;

  CountDashboardModel({
    required this.iTotalParks,
    required this.iTotalGeotagged,
    required this.iTotalInspection,
    required this.iTotalInspectionAmt,
    required this.totalResolvedInspection,
    required this.iTotalReceviedAmt,
  });
}

//   ------ ParkListByAgency-------.

class ParkListByAgencyModel {

  final int iParkId;
  final String sParkName;
  final int iNoOfWorkers;
  final String sSupervisor;
  final String sAssetDirector;
  final String sDuptyDirector;
  final String sDirector;
  final String sAgencyName;
  final int iAgencyCode;
  final String fArea;
  final double fLatitude;
  final double fLongitude;
  final String sGoogleLocation;
  final String sParkPhoto;

  ParkListByAgencyModel({
    required this.iParkId,
    required this.sParkName,
    required this.iNoOfWorkers,
    required this.sSupervisor,
    required this.sAssetDirector,
    required this.sDuptyDirector,
    required this.sDirector,
    required this.sAgencyName,
    required this.iAgencyCode,
    required this.fArea,
    required this.fLatitude,
    required this.fLongitude,
    required this.sGoogleLocation,
    required this.sParkPhoto,
  });
}

