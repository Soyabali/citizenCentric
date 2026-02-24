
import 'package:rxdart/rxdart.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../domain/model/model.dart';
import '../../domain/usecase/ParkListByAgencyUseCase.dart';
import '../base/baseviewmodel.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../common/state_renderer/state_renderer.dart';

class AgencyWiseDetalsViewModel extends BaseViewModel implements AgencyWiseDetalsViewModelInputs,

    AgencyWiseDetalsViewModelOutputs {

  // usecase
   //final CountDashboardUseCase _useCase;
  final ParkListByAgencyUseCase _useCase;

  // rx dart
  BehaviorSubject<List<ParkListByAgencyModel>> _dashboardController = BehaviorSubject<List<ParkListByAgencyModel>>();
  AgencyWiseDetalsViewModel(this._useCase);

  @override
  void start() {
    // call api
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    AppPreferences appPreferences = instance<AppPreferences>();
    final userData = await appPreferences.getLoginUserData();
    final iUserId = "${userData?['userId']}";

    print("📡 Dashboard API CALL STARTED | userId = $iUserId");

    inputState.add(
      LoadingState(
        stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE,
      ),
    );

    final result = await _useCase.execute(ParkListByAgencyInput(iUserId));// put a required parameter in a api here

    result.fold(
      // ❌ FAILURE
          (failure) {
        print("❌ Dashboard API FAILURE: ${failure.message}");

        inputState.add(
          ErrorState(
            StateRendererType.FULL_SCREEN_ERROR_STATE,
            failure.message,
          ),
        );
      },

      // ✅ SUCCESS
          (model) {
        // Push data to stream
        inputAgencyWiseDetail.add(model);
        inputState.add(ContentState());
      },
    );
  }
  // INPUT

  @override
  Sink<List<ParkListByAgencyModel>>  get inputAgencyWiseDetail => _dashboardController.sink;
  // OUTPUT
  @override
  Stream<List<ParkListByAgencyModel>> get outputDashboard => _dashboardController.stream;

  @override
  void dispose() {
    _dashboardController.close();
    super.dispose();
  }

  @override
  // TODO: implement outputAgencyWiseDetial
  Stream<List<ParkListByAgencyModel>> get outputAgencyWiseDetial => _dashboardController.stream;
}

abstract class AgencyWiseDetalsViewModelInputs {
  Sink<List<ParkListByAgencyModel>> get inputAgencyWiseDetail;
}

abstract class AgencyWiseDetalsViewModelOutputs {
  Stream<List<ParkListByAgencyModel>> get outputAgencyWiseDetial;
}

