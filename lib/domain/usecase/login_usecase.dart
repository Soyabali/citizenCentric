
import 'package:citizencentric/data/network/failure.dart';
import 'package:citizencentric/data/request/request.dart';
import 'package:citizencentric/domain/model/model.dart';
import 'package:citizencentric/domain/repository/repository.dart';
import 'package:citizencentric/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {

  Repository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUseCaseInput input) async {
    return await _repository.login(LoginRequest(input.sContactNo, input.sPassword));
  }
}

class LoginUseCaseInput {
  String sContactNo;
  String sPassword;

  LoginUseCaseInput(this.sContactNo, this.sPassword);
}

