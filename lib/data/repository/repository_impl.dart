
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
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        final responses = await _remoteDataSource.login(loginRequest); // List<AuthenticationResponse>

        // Loop through the responses to find a success
        for (var item in responses) {
          if (item.result == "1") {
            return Right(item.toDomain()); // Return first success case
          }
        }
        // If no item was successful:
        return Left(
          Failure(
            int.tryParse(responses.first.result ?? '') ?? ApiInternalStatus.FAILURE,
            responses.first.msg ?? ResponseMessage.DEFAULT,
          ),
        );

      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}