
import '../network/app_api.dart';
import '../request/request.dart';
import '../responses/response.dart';

abstract class RemoteDataSource {
  Future<AuthenticationResponse> login(LoginRequest loginRequest);
  //Future<List<AuthenticationResponse>> login(LoginRequest loginRequest);
  Future<List<ChangePasswordResponse>> changePassword(ChangePassWordRequest loginRequest);
  Future<List<StafListResponse>> stafflist(StaffListRequest staffListRequest);
  //Future<List<InspectionStatusListResponse>> inspectionList(InspectionListRequest inspectionListRequest);
  Future<InspectionStatusListResponse> inspectionList(
      InspectionListRequest inspectionListRequest);
  // Count DashBoard
  Future<CountDashboardListResponse> countDashboard(CountDashboardRequest countDashboardRequest);
  // Agency Wise Details
  Future<ParkListByAgencyItemResponseDetail> parklistByAgency(ParkListByAgencyRequest parkListByAgencyRequest);

  // LoginRequest : This is the LoginBody class
  // AuthenticationResponse : this is login response
}

class RemoteDataSourceImplementer implements RemoteDataSource {

  final AppServiceClient _appServiceClient;// This is a file where i mention api endPoint
  // and if api is a post type here i declare the body of the api
  RemoteDataSourceImplementer(this._appServiceClient);

  // -------------login -----------

  @override
  Future<AuthenticationResponse> login(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
      loginRequest.sContactNo,
      loginRequest.sPassword,
      loginRequest.sAppVersion,
    );
  }

  // ------------changePassword--------

  @override
  Future<List<ChangePasswordResponse>> changePassword(ChangePassWordRequest changePasswordRequest) async {
    // AuthenticationResponse , this is api response auto generate file
    // LoginRequest , is a Api body field mention.

    return await _appServiceClient.changePassword(
        changePasswordRequest.sOldPassword,
        changePasswordRequest.sNewPassword,
        changePasswordRequest.iUserId
    );
  }

  //  -----STAFFLIST-------

  @override
  Future<List<StafListResponse>> stafflist(StaffListRequest staffListRequest) async {
    // here you pass a entire object into the _appServiceClent not a particular fields
    return await _appServiceClient.staffList(staffListRequest);
  }
  //   ---inspection List-----.

  @override
  Future<InspectionStatusListResponse> inspectionList(
      InspectionListRequest inspectionListRequest) async {
    // here call a api end point api path
    return await _appServiceClient.inspectionList(inspectionListRequest);

  }
  // CountDashBoard
  @override
  Future<CountDashboardListResponse> countDashboard(CountDashboardRequest countDashboardRequest) async {
    // here call a api end point api path
    return await _appServiceClient.countDashboard(
      countDashboardRequest,
    );
  }
  // AgencyWise Details--
  @override
  Future<ParkListByAgencyItemResponseDetail> parklistByAgency(ParkListByAgencyRequest parkListByAgencyRequest) async {
    // here call a api end point api path
    return await _appServiceClient.parklist(
      parkListByAgencyRequest,
    );
  }

}