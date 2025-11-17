
import 'package:citizencentric/data/network/parse_error_logger.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../../app/constant.dart';
import '../responses/response.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: Constant.baseUrl)
abstract class AppServiceClient{
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  // @POST("hrmsLogin/hrmsLogin")
  // Future<AuthenticationResponse> login(
  //     @Field("sContactNo") String sContactNo,
  //     @Field("sPassword") String sPassword);

  @POST("hrmsLogin/hrmsLogin")
  Future<List<AuthenticationResponse>> login(
      @Field("sContactNo") String sContactNo,
      @Field("sPassword") String sPassword);

}
