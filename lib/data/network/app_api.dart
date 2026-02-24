
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

  @POST("AppLogin/AppLogin")
  Future<AuthenticationResponse> login(
      @Field("sContactNo") String sContactNo,
      @Field("sPassword") String sPassword,
      @Field("sAppVersion") String sAppVersion,
      );


  //  --------Api ChangePassword-------

  @POST("ChangePassword/ChangePassword")
  Future<List<ChangePasswordResponse>> changePassword(
      @Field("sOldPassword") String sPassword,
      @Field("sNewPassword") String sNewPassword,
      @Field("iUserId") String iUserId);


  // ------StaffList Api---------.
  @POST("hrmsStaffList/hrmsStaffList")
  Future<List<StafListResponse>> staffList(

     @Body() StaffListRequest request);

  //  --inspection list

  @POST("InspectionStatus/InspectionStatus")
  Future<InspectionStatusListResponse> inspectionList(
      @Body() InspectionListRequest request,
      );
  // CountDashBoard

  @POST("CountDashboard/CountDashboard")
  Future<CountDashboardListResponse> countDashboard(
      @Body() CountDashboardRequest request,
      );
  // Agency Wise Details
  @POST("ParkListByAgency/ParkListByAgency")
  Future<ParkListByAgencyItemResponseDetail> parklist(
      @Body() ParkListByAgencyRequest request,
      );

}
