
import '../../domain/model/model.dart';
import '../responses/response.dart';

const EMPTY = "";
const ZERO = 0;

//-------User DataResponse Mapper


extension UserDataResponseMapper on UserDataResponse {
  Authentication toDomain() {
    return Authentication(
      userId: userId ?? ZERO,
      name: name ?? EMPTY,
      contactNo: contactNo ?? EMPTY,
      designationName: designationName ?? EMPTY,
      designationCode: designationCode ?? ZERO,
      departmentCode: departmentCode ?? ZERO,
      userTypeCode: userTypeCode ?? ZERO,
      token: token ?? EMPTY,
      lastLoginAt: lastLoginAt ?? EMPTY,
      agencyCode: agencyCode ?? ZERO,
    );
  }
}

// --------changePassworMapper-------

extension ChangePasswordResponseMapper on ChangePasswordResponse {
  // AuthenticationResponse is a response auto generate file
  // Authentication this is a model class
  ChangePasswordModel toDomain() {
    return ChangePasswordModel(
      //result: result ?? EMPTY,
      //msg: msg ?? EMPTY,
      Result: Result ?? EMPTY,
      Msg: Msg ?? EMPTY,
    );
  }
}
//--------StaffListMapper---------
extension StaffListResponseMapper on StafListResponse {
  // AuthenticationResponse is a response auto generate file
  // Authentication this is a model class
  StaffListModel toDomain() {
    return StaffListModel(
      sEmpCode: sEmpCode ?? EMPTY,
      sEmpName: sEmpName ?? EMPTY,
      sContactNo: sContactNo ?? EMPTY,
      sLocName: sLocName ?? EMPTY,
      sDsgName: sDsgName ?? EMPTY,
      sEmpImage: sEmpImage ?? EMPTY
    );
  }
}
//  -- inspection List

extension InspectionStatusResponseMapper

on InspectionStatusItemResponse {

  InspectionStatusModel toDomain() {
    return InspectionStatusModel(
      tranNo: iTranNo ?? 0,
      parkId: iParkId ?? 0,
      parkName: sParkName ?? EMPTY,
      sectorName: sSectorName ?? EMPTY,
      divisionName: sDevisionName ?? EMPTY,
      reportType: sReportType ?? EMPTY,
      penaltyCharges: fPaneltyCharges ?? 0.0,
      description: sDescription ?? EMPTY,
      latitude: fLatitude ?? 0.0,
      longitude: fLongitude ?? 0.0,
      googleLocation: sGoogleLocation ?? EMPTY,
      photoUrl: sPhoto ?? EMPTY,
      agencyName: sAgencyName ?? EMPTY,
      inspectedBy: sInspBy ?? EMPTY,
      inspectedAt: dInspAt ?? EMPTY,
      status: sStatus ?? EMPTY,
    );
  }
}
//  CounterDashBoard mapper---.

extension CountDashboardResponseMapper
on CountDashboardItemResponse {

  CountDashboardModel toDomain() {
    return CountDashboardModel(
      iTotalParks: iTotalParks ?? 0,
      iTotalGeotagged: iTotalGeotagged ?? 0,
      iTotalInspection: iTotalInspection ?? 0,
      iTotalInspectionAmt: iTotalInspectionAmt ?? 0,
      totalResolvedInspection: totalResolvedInspection ?? 0,
      iTotalReceviedAmt: iTotalReceviedAmt ?? 0,
    );
  }
}
//  -----Agency Wise DETAIL MAPPER
extension ParkListByAgencyMapper on ParkListByAgencyItemResponse {
  ParkListByAgencyModel toDomain() {
    return ParkListByAgencyModel(
      iParkId: iParkId ?? 0,
      sParkName: sParkName ?? "",
      iNoOfWorkers: iNoOfWorkers ?? 0,
      sSupervisor: sSupervisor ?? "",
      sAssetDirector: sAssetDirector ?? "",
      sDuptyDirector: sDuptyDirector ?? "",
      sDirector: sDirector ?? "",
      sAgencyName: sAgencyName ?? "",
      iAgencyCode: iAgencyCode ?? 0,
      fArea: fArea ?? "",
      fLatitude: fLatitude ?? 0.0,
      fLongitude: fLongitude ?? 0.0,
      sGoogleLocation: sGoogleLocation ?? "",
      sParkPhoto: sParkPhoto ?? "",
    );
  }
}
