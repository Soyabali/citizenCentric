import 'package:rxdart/rxdart.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../domain/model/model.dart';
import '../../domain/usecase/countdashboard_usecase.dart';
import '../base/baseviewmodel.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../common/state_renderer/state_renderer.dart';

class CountDashboardViewModel extends BaseViewModel implements CountDashboardViewModelInputs,
        CountDashboardViewModelOutputs {
  // usecase
  final CountDashboardUseCase _useCase;
  // rx dart
  final BehaviorSubject<CountDashboardModel> _dashboardController = BehaviorSubject<CountDashboardModel>();
  CountDashboardViewModel(this._useCase);

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

    final result = await _useCase.execute(CountDashboardInput(iUserId));// put a required parameter in a api here

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
        inputDashboard.add(model);

        inputState.add(ContentState());
      },
    );
  }

  // INPUT
  @override
  // put the data into the stream

  Sink<CountDashboardModel> get inputDashboard => _dashboardController.sink;

  // OUTPUT
  @override
  Stream<CountDashboardModel> get outputDashboard => _dashboardController.stream;

  @override
  void dispose() {
    _dashboardController.close();
    super.dispose();
  }
}

abstract class CountDashboardViewModelInputs {
  Sink<CountDashboardModel> get inputDashboard;
}

abstract class CountDashboardViewModelOutputs {
  Stream<CountDashboardModel> get outputDashboard;
}