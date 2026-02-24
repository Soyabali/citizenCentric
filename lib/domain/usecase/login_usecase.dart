
import 'package:citizencentric/data/network/failure.dart';
import 'package:citizencentric/data/request/request.dart';
import 'package:citizencentric/domain/model/model.dart';
import 'package:citizencentric/domain/repository/repository.dart';
import 'package:citizencentric/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {
  //  BaseUseCase , this is a BaseUseCase class that here i manage a login or Any Other UseCase.
  // LoginUseCaseInput this is a class that have a parameter to api or api body field mentions.
  // Authentication , this is a model class , where we stored the parameter.

  Repository _repository;
  // this is a Repository class that here i manage a login or Any Other Repository.

  LoginUseCase(this._repository);// this is a constructor that take a parameter _repository.

  // Authentication this is a loginModel class

  @override
  Future<Either<Failure, Authentication>> execute(LoginUseCaseInput input) async {
    // here we call a login function that is put into the Repository class
    // in a login function ,LoginRequest is a class that have a field of login api body
    return await _repository.login(LoginRequest(input.sContactNo, input.sPassword,input.sAppVersion));
  }
}

class LoginUseCaseInput {
  String sContactNo;
  String sPassword;
  String sAppVersion;

  LoginUseCaseInput(this.sContactNo, this.sPassword,this.sAppVersion);
}

