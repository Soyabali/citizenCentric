
import '../network/app_api.dart';
import '../request/request.dart';
import '../responses/response.dart';

abstract class RemoteDataSource {
  Future<List<AuthenticationResponse>> login(LoginRequest loginRequest);
  // LoginRequest : This is the LoginBody class
  // AuthenticationResponse : this is a AutoGenerateFile of a login response
}

class RemoteDataSourceImplementer implements RemoteDataSource {

  AppServiceClient _appServiceClient;// This is a file where i mention api endPoint
  // and if api is a post type here i declare the body of the api
  RemoteDataSourceImplementer(this._appServiceClient);

  @override
  Future<List<AuthenticationResponse>>  login(LoginRequest loginRequest) async {
   // AuthenticationResponse , this is api response auto generate file
    // LoginRequest , is a Api body field mention.

    return await _appServiceClient.login(
    loginRequest.sContactNo,
    loginRequest.sPassword);
  }
}