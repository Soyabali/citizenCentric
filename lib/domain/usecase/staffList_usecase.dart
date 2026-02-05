
import 'package:citizencentric/data/request/request.dart';
import 'package:dartz/dartz.dart';
import '../../data/network/failure.dart';
import '../model/model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class StaffListUseCase implements BaseUseCase<StaffListInput, List<StaffListModel>>
{
  //  BaseUseCase , this is a BaseUseCase class that here i manage a login or Any Other UseCase.
  // LoginUseCaseInput this is a class that have a parameter to api or api body field mentions.
  // StaffListModel , this is a model class , where we stored the parapeter.

  final Repository _repository;
  // this is a Repository class that here i manage a login or Any Other Repository.

  StaffListUseCase(this._repository);// this is a constructor that take a parameter _repository.

  // Authentication this is a loginModel class

  @override
  Future<Either<Failure, List<StaffListModel>>> execute(StaffListInput input) async {
    return await _repository.staffList(StaffListRequest(input.sEmpCode));
  }
}

class StaffListInput {
  String sEmpCode;
  // constructor
  StaffListInput(this.sEmpCode);
}