import 'package:rxdart/rxdart.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../domain/model/model.dart';
import '../../domain/usecase/BindDivisionUseCase.dart';
import '../base/baseviewmodel.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../common/state_renderer/state_renderer.dart';

class BindDivisionViewModel extends BaseViewModel
    implements BindDivisionViewModelInputs, BindDivisionViewModelOutputs {

  // usecase
  final BindDivisionUseCase _useCase;

  // rx dart
  final BehaviorSubject<List<BindDivisionModel>> _bindDivisionController =
      BehaviorSubject<List<BindDivisionModel>>();

  BindDivisionViewModel(this._useCase);

  @override
  void start() {
    // call api
    _loadBindDivision();
  }

  Future<void> _loadBindDivision() async {
    AppPreferences appPreferences = instance<AppPreferences>();
    final userData = await appPreferences.getLoginUserData();
    final iUserId = "${userData?['userId']}";

    print("📡 BindDivision API CALL STARTED | userId = $iUserId");

    inputState.add(
      LoadingState(
        stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE,
      ),
    );

    final result = await _useCase.execute(BindDivisionInput(iUserId));

    result.fold(
      // ❌ FAILURE
      (failure) {
        print("❌ BindDivision API FAILURE: ${failure.message}");

        inputState.add(
          ErrorState(
            StateRendererType.FULL_SCREEN_ERROR_STATE,
            failure.message,
          ),
        );
      },

      // ✅ SUCCESS
      (model) {
        print("✅ BindDivision API SUCCESS: ${model.length} items received");
        // Push data to stream
        inputBindDivision.add(model);
        inputState.add(ContentState());
      },
    );
  }

  // INPUT
  @override
  Sink<List<BindDivisionModel>> get inputBindDivision =>
      _bindDivisionController.sink;

  // OUTPUT
  @override
  Stream<List<BindDivisionModel>> get outputBindDivision =>
      _bindDivisionController.stream;

  @override
  void dispose() {
    _bindDivisionController.close();
    super.dispose();
  }
}

abstract class BindDivisionViewModelInputs {
  Sink<List<BindDivisionModel>> get inputBindDivision;
}

abstract class BindDivisionViewModelOutputs {
  Stream<List<BindDivisionModel>> get outputBindDivision;
}

