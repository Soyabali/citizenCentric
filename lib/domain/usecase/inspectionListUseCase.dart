import 'package:citizencentric/data/request/request.dart';
import 'package:dartz/dartz.dart';
import '../../data/network/failure.dart';
import '../model/model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class InspectionListUseCase implements BaseUseCase<InspectionListInput,List<InspectionStatusModel>>
{
  // BaseUseCase , this is a BaseUseCase class that here i manage a login or Any Other UseCase.
  // LoginUseCaseInput this is a class that have a parameter to api or api body field mentions.
  // StaffListModel , this is a model class , where we stored the parameter.

  final Repository _repository;
  // this is a Repository class that here i manage a login or Any Other Repository.

  InspectionListUseCase(this._repository);  // this is a constructor that take a parameter _repository.
  // Authentication this is a loginModel class

  @override
  Future<Either<Failure, List<InspectionStatusModel>>> execute(InspectionListInput input) async {
    // you should be carefully here you pass a parameter value into the StaffListRequest
    return await _repository.inspectionList(InspectionListRequest(input.iUserId));
  }
}

class InspectionListInput {
  String iUserId;
  // constructor
  InspectionListInput(this.iUserId);
}