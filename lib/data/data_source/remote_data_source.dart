
import '../network/app_api.dart';
import '../request/request.dart';
import '../responses/response.dart';

abstract class RemoteDataSource {
  Future<AuthenticationResponse> login(LoginRequest loginRequest);
  //Future<List<AuthenticationResponse>> login(LoginRequest loginRequest);
  Future<List<ChangePasswordResponse>> changePassword(ChangePassWordRequest loginRequest);
  Future<List<StafListResponse>> stafflist(StaffListRequest staffListRequest);

  // LoginRequest : This is the LoginBody class
  // AuthenticationResponse : this is login response
}

class RemoteDataSourceImplementer implements RemoteDataSource {

  AppServiceClient _appServiceClient;// This is a file where i mention api endPoint
  // and if api is a post type here i declare the body of the api
  RemoteDataSourceImplementer(this._appServiceClient);

  // -------------login -----------

  @override
  @override
  Future<AuthenticationResponse> login(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
      loginRequest.sContactNo,
      loginRequest.sPassword,
      loginRequest.sAppVersion,
    );
  }
  // Future<List<AuthenticationResponse>>  login(LoginRequest loginRequest) async {
  //  // AuthenticationResponse , this is api response auto generate file
  //   // LoginRequest , is a Api body field mention.
  //
  //   return await _appServiceClient.login(
  //   loginRequest.sContactNo,
  //   loginRequest.sPassword,
  //   );
  // }
  // ------------changePassword--------

  Future<List<ChangePasswordResponse>> changePassword(ChangePassWordRequest changePasswordRequest) async {
    // AuthenticationResponse , this is api response auto generate file
    // LoginRequest , is a Api body field mention.

    return await _appServiceClient.changePassword(
        changePasswordRequest.sContactNo,
        changePasswordRequest.sOldPassword,
        changePasswordRequest.sNewPassword
    );
  }

  //  -----STAFFLIST-------

  Future<List<StafListResponse>> stafflist(StaffListRequest staffListRequest) async {
    // here you pass a entire object into the _appServiceClent not a particular fields
    return await _appServiceClient.staffList(staffListRequest);
  }


}