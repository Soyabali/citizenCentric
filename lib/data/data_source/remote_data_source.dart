
import '../network/app_api.dart';
import '../request/request.dart';
import '../responses/response.dart';

abstract class RemoteDataSource {
  Future<List<AuthenticationResponse>> login(LoginRequest loginRequest);
}

class RemoteDataSourceImplementer implements RemoteDataSource {

  AppServiceClient _appServiceClient;
  RemoteDataSourceImplementer(this._appServiceClient);

  @override
  Future<List<AuthenticationResponse>>  login(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
    loginRequest.sContactNo,
    loginRequest.sPassword);
  }
}