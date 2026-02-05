
import 'package:citizencentric/data/data_source/remote_data_source.dart';
import 'package:citizencentric/data/mapper/mappper.dart';
import 'package:citizencentric/data/network/failure.dart';
import 'package:citizencentric/data/network/network_info.dart';
import 'package:citizencentric/data/request/request.dart';
import 'package:citizencentric/domain/model/model.dart';
import 'package:citizencentric/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';
import '../data_source/local_data_source.dart';
import '../network/error_handler.dart';

class RepositoryImpl extends Repository {

  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImpl(this._remoteDataSource, this._localDataSource,
      this._networkInfo);


  @override
  // Future<Either<Failure, Authentication>> login(LoginRequest loginRequest) async {
  //
  //   if (await _networkInfo.isConnected) {
  //
  //     try {
  //       final responses = await _remoteDataSource.login(loginRequest); // List<AuthenticationResponse>
  //
  //       for (var item in responses) {
  //         if (item.result == "1") {
  //           print("----item.result --55--:  ${item.result}");
  //           print("-Token  56: ${item.token}");
  //           return Right(item.toDomain()); // Return first success case
  //         }
  //       }
  //       // If no item was successful:
  //       return Left(
  //         // is another part of a {{Either}} concept. Left if api response failed then go under Left
  //         Failure(
  //           int.tryParse(responses.first.result ?? '') ?? ApiInternalStatus.FAILURE,
  //           responses.first.msg ?? ResponseMessage.DEFAULT,
  //         ),
  //       );
  //     } catch (error) {
  //       return Left(ErrorHandler.handle(error).failure);
  //     }
  //   } else {
  //     return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
  //   }
  // }

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {

    if (await _networkInfo.isConnected) {
      try {
        final response =
        await _remoteDataSource.login(loginRequest);
        // response is AuthenticationResponse

        if (response.result == "1" &&
            response.data != null &&
            response.data!.isNotEmpty) {
          final user = response.data!.first;
          return Right(user.toDomain());

        } else {
          return Left(
            Failure(
              int.tryParse(response.result ?? '') ??
                  ApiInternalStatus.FAILURE,
              response.msg ?? ResponseMessage.DEFAULT,
            ),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }


  // -----ChangePassword repository---
  Future<Either<Failure, ChangePasswordModel>> changePassword(
      ChangePassWordRequest changePasswordRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        final responses = await _remoteDataSource.changePassword(
            changePasswordRequest); // List<AuthenticationResponse>
        for (var item in responses) {
          if (item.Result == "1") {
            print("----item.result --145--:  ${item.Result}");

            return Right(item.toDomain()); // Return first success case
          } else {
            print('-----xxxxxxxx------failed---149-----');
          }
        }
        // If no item was successful:
        return Left(
          // is another part of a {{Either}} concept. Left if api response failed then go under Left

          Failure(
            int.tryParse(responses.first.Result ?? '') ??
                ApiInternalStatus.FAILURE,
            responses.first.Msg ?? ResponseMessage.DEFAULT,
          ),

        );
      } catch (error) {
        return Left(ErrorHandler
            .handle(error)
            .failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  // ------StaffList---------
  // not a confuse getHome == functin name change staffList
  Future<Either<Failure, List<StaffListModel>>> staffList(StaffListRequest request) async {
    try {
      // get from cache
      final response = await _localDataSource.getHomeFromCache();
      final list = response.map((e) => e.toDomain()).toList();
      return Right(list);
    } catch (cacheError) {
      // we have cache error so we should call api
      if (await _networkInfo.isConnected) {
        try {
          final responses = await _remoteDataSource.stafflist(request);

          if (responses.isNotEmpty) {
            _localDataSource.saveHomeToCache(responses);
            final list = responses.map((e) => e.toDomain()).toList();
            return Right(list);
          }
          return Left(Failure(
            ResponseCode.NO_DATA,
            "No staff found",
          ));
        } catch (error) {
          return Left(ErrorHandler
              .handle(error)
              .failure);
        }
      } else {
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }
}







