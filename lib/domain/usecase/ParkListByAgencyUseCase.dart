
import 'package:dartz/dartz.dart';
import '../../data/network/failure.dart';
import '../../data/request/request.dart';
import '../model/model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';

class ParkListByAgencyUseCase implements BaseUseCase<ParkListByAgencyInput,List<ParkListByAgencyModel>> {

  final Repository _repository;
  ParkListByAgencyUseCase(this._repository);

  @override
  Future<Either<Failure, List<ParkListByAgencyModel>>> execute(
      ParkListByAgencyInput input) async {
    // here we put api body required parameter
    return await _repository.parkListByAgency(ParkListByAgencyRequest(input.iAgencyCode)
    );
  }
}
class ParkListByAgencyInput {
  String iAgencyCode;
  ParkListByAgencyInput(this.iAgencyCode);
}