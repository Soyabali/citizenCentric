
import 'package:citizencentric/data/data_source/remote_data_source.dart';
import 'package:citizencentric/data/mapper/mappper.dart';
import 'package:citizencentric/data/network/failure.dart';
import 'package:citizencentric/data/network/network_info.dart';
import 'package:citizencentric/data/request/request.dart';
import 'package:citizencentric/domain/model/model.dart';
import 'package:citizencentric/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';
import '../network/error_handler.dart';

class RepositoryImpl extends Repository {

  RemoteDataSource _remoteDataSource;
  NetworkInfo _networkInfo;
  RepositoryImpl(this._remoteDataSource, this._networkInfo);


  @override
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest) async {
    // this is the most important key concept to understand what is done here on a login function
    // first of all i understand {{Future<Either<Failure, Authentication>>}} , actully
    // login function return in a Future {{Either<Failure, Authentication>}} , here
    // you should understand {{Either}} this is a concept of Dart programming language
    // in a Either concept you get a left and right two terminology
    // left means failure its means api response is failed.
    // right means success its means api response is success after that we take a diff - 2
    // action behafe of left and right
    // after that you should understand {{<Failure, Authentication>}} , here there is a two
    // classes first one is a Failure and second is a Authentication
    // carefully understand Failure and Authentication, {{Failure}} is a class where i mention msg all
    // case of behafe of http code response here mention errorMsg and error Code.
    // {{Authentication}}, this is a api response modell class
    // you should understand {{login(LoginRequest loginRequest)}} , here login is a function name.
    // {{LoginRequest}} , is a class that have a parameter to api or api body field mentions.


    //
    if (await _networkInfo.isConnected) {
      //  here we check internet is connected or not {{_networkInfo.isConnected}}
      // we create a {{NetworkInfo}} class that is used to check internet

      try {
        final responses = await _remoteDataSource.login(loginRequest); // List<AuthenticationResponse>
        // here you get a api response this is a most important point
        // to fetch data FROM a Api you should carefully {{what type of data your api return}}
        // accoding to api response you fetch , different - 2 api have a send differnt - 2 data format
        // here you get a data in a list should i hadle list and take a action.

        // Loop through the responses to find a success

        for (var item in responses) {
          if (item.result == "1") {

            print("----item.result --55--:  ${item.result}");
            print("-Token: ${item.token}");

            // here i applied dart important concept left and right as a above mentions {{Either}} concept.
            // here you applied a logic {item.result == "1")}, if condition is true
            // then according to Either concept we go Right its mens true or success.
            //
            return Right(item.toDomain()); // Return first success case
            // this is the most important concept here we fill data into the model Via mapper
            // here when we click the toDomain() function then open a mapper class
            // into the mapper i have a syntak such as {{Authentication toDomain() }}, Authentication is
            // a model and toDomain() is a function of mapper class that manage data should not be fill null
            // data may be int string or list or images anything.

          }
        }
        // If no item was successful:
        return Left(
          // is another part of a {{Either}} concept. Left if api response failed then go under Left
          Failure(
            int.tryParse(responses.first.result ?? '') ?? ApiInternalStatus.FAILURE,
            responses.first.msg ?? ResponseMessage.DEFAULT,
          ),
          //  here you should be got it if response is faild then i called {{Failure}} class
          // in this class i have two fields codes and msg that indicat http error.
          // here is another class {ApiInternalStatus.FAILURE}, this is a class here
          // i mention two value one is a Sucess and another value is a failure
          // here this is another class {{ResponseMessage.DEFAULT}}, this is a class
          // that mention a msg
        );

      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
        // This is anothe important part if i get an error and comes in a catch block
        // then i return {{Left(ErrorHandler.handle(error).failure);}}, we should clearly
        // understand here {{Left}} is a Either concept clear
        // another {{ErrorHandler}} , this is a class , this class i mention error_handler.dart file.
        // Actully , {ErrorHandler} is a class that dynamically show the error msg
        // Actully this is the ErrorHandler class : {{class ErrorHandler implements Exception {
        //   late Failure failure;
        //
        //   ErrorHandler.handle(dynamic error) {
        //     if (error is DioException) {
        //       // dio error so its error from response of the API
        //       failure = _handleError(error);
        //     } else {
        //       // default error
        //       failure = DataSource.DEFAULT.getFailure();
        //     }
        //   }}}
        //  Actullty {_handleError} is a a function that return error in a future
        // this is a class that dart exceptin or error that i manage stactically
        // such as {{Failure _handleError(DioError error) {
        //     switch (error.type) {
        //       case DioExceptionType.connectionTimeout:
        //         return DataSource.CONNECT_TIMEOUT.getFailure();}}
        // here i appled a switch in a switch there are multiple case of error
        // for example {{ case DioExceptionType.connectionTimeout:
        //         return DataSource.CONNECT_TIMEOUT.getFailure();}}
        // if case DioExceptionType.connectionTimeout: then return DataSource.CONNECT_TIMEOUT.getFailure();}}
        // DataSource is a enum that have a multiple case
        // here {getFailure}  is a function that return errorCODE and msg
        // you can see here : {{Failure getFailure() {
        //     switch (this) {
        //       case DataSource.BAD_REQUEST:
        //         return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);
        //       case DataSource.FORBIDDEN:}} , here in a switch case there are
        // multiple case , for example { case DataSource.BAD_REQUEST:}then return
        // return {{Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);}}


      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      // here again i got a Left case in this case i called again getFailure
      // in this functin its a fiends No_INTERNET_CONNECTION case and return mas
      // that is written a switch case
    }
  }
}