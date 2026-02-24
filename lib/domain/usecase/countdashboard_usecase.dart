import 'package:citizencentric/data/request/request.dart';
import 'package:dartz/dartz.dart';
import '../../data/network/failure.dart';
import '../model/model.dart';
import '../repository/repository.dart';
import 'base_usecase.dart';


class CountDashboardUseCase implements BaseUseCase<CountDashboardInput,CountDashboardModel> {

  final Repository _repository;
  CountDashboardUseCase(this._repository);

  @override
  Future<Either<Failure, CountDashboardModel>> execute(
      CountDashboardInput input) async {
    // here we put api body required parameter
    return await _repository.countDashboard(CountDashboardRequest(input.iUserId)
    );
  }
}
class CountDashboardInput {
  String iUserId;
  CountDashboardInput(this.iUserId);
}