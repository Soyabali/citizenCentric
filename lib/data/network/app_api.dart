
import 'package:citizencentric/data/network/parse_error_logger.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../../app/constant.dart';
import '../request/request.dart';
import '../responses/response.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constant.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;
  //  ------Login Ali--------
  @POST("hrmsLogin/hrmsLogin")  // <List<AuthenticationResponse>>  this is the most
  // important part we should see api response after that we should return data as a api givern
  // here LoginResponse api return data in a list ex [{}], so we return the LIST
  Future<List<AuthenticationResponse>> login(
      @Field("sContactNo") String sContactNo,// this is the field of api
      @Field("sPassword") String sPassword);

  //  --------Api ChangePassword-------

  @POST("hrmsReplacePassword/hrmsReplacePassword")
  Future<List<ChangePasswordResponse>> changePassword(
      @Field("sContactNo") String sContactNo,// this is the field of api
      @Field("sOldPassword") String sPassword,
      @Field("sNewPassword") String sNewPassword);

  // ------StaffList Api---------.
  @POST("hrmsStaffList/hrmsStaffList")
  Future<List<StafListResponse>> staffList(

     @Body() StaffListRequest request);
}
