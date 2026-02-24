
import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';
import '../../data/request/request.dart';
import '../model/model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class ChangPasswordUseCase implements BaseUseCase<ChangePassWordInput, ChangePasswordModel> {
  //  BaseUseCase , this is a BaseUseCase class that here i manage a login or Any Other UseCase.
  // LoginUseCaseInput this is a class that have a parameter to api or api body field mentions.
  // Authentication , this is a model class , where we stored the parapeter.

  final Repository _repository;
  // this is a Repository class that here i manage a login or Any Other Repository.

  ChangPasswordUseCase(this._repository);  // this is a constructor that take a parameter _repository.
  // Authentication this is a loginModel class

  @override
  Future<Either<Failure, ChangePasswordModel>> execute(ChangePassWordInput input) async {
    return await _repository.changePassword(ChangePassWordRequest(
        input.sOldPassword,
        input.sNewPassword,
        input.iUserId
    ));
  }
}

class ChangePassWordInput {
  String sOldPassword;
  String sNewPassword;
  String iUserId;

  ChangePassWordInput(this.sOldPassword,this.sNewPassword,this.iUserId);
}