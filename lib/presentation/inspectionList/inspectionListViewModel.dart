import 'dart:async';
import 'package:citizencentric/presentation/base/baseviewmodel.dart';
import 'package:rxdart/rxdart.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../domain/model/model.dart';
import '../../domain/usecase/inspectionListUseCase.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../common/state_renderer/state_renderer.dart';

class InspectionListViewModel extends BaseViewModel
    implements InspectionListViewModelInputs, InspectionListViewModelOutput {
  // ================================
  // 1. USE CASE (Business Logic)
  // ================================
  final InspectionListUseCase _inspectionListUseCase;

  // ================================
  // 2. STREAM CONTROLLER (RX DART)
  // BehaviorSubject keeps last value
  // ================================
  final BehaviorSubject<List<InspectionStatusModel>> _inspectionListController =
      BehaviorSubject<List<InspectionStatusModel>>();

  // ================================
  // 3. CONSTRUCTOR
  // ================================
  InspectionListViewModel(this._inspectionListUseCase);

  // ================================
  // 4. INPUT OBJECT (API PARAM)
  // ================================
 // final inspectionListObject = InspectionListObject(iUserId: "");

  // ================================
  // 5. START VIEWMODEL
  // ================================

  @override
  void start() async {
    _getInspectionList();
  }

  // ================================
  // 6. DISPOSE (VERY IMPORTANT)
  // ================================
  @override
  void dispose() {
    _inspectionListController.close();
    super.dispose();
  }

  // ================================
  // 7. API CALL FUNCTION
  // ================================

  Future<void> _getInspectionList() async {
    AppPreferences appPreferences = instance<AppPreferences>();
    final userData = await appPreferences.getLoginUserData();
    var iUserId = "${userData?['userId']}";
    print("------66-----$iUserId");

    // 🔹 Show loading state

    inputState.add(
      LoadingState(
        stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE,
      ),
    );
    print("📡 Inspection API CALL STARTED");
    try {
      final result = await _inspectionListUseCase.execute(
        // InspectionListInput(inspectionListObject.iUserId),
        InspectionListInput(iUserId),
      );

      result.fold(
        // ❌ FAILURE
        (failure) {
          print("❌ API FAILURE: ${failure.message}");

          inputState.add(
            ErrorState(
              StateRendererType.FULL_SCREEN_ERROR_STATE,
              failure.message,
            ),
          );
        },
        // ✅ SUCCESS
        (list) {
          if (list == null || list.isEmpty) {
            print("⚠️ API SUCCESS BUT DATA IS NULL OR EMPTY");
          } else {
            print("✅ API SUCCESS | TOTAL RECORDS: ${list.length}");

            // 🔍 Print each item (optional but useful)
            for (var item in list) {
              print(
                "🧾 Park: ${item.agencyName}, "
                "Sector: ${item.parkName}, "
                "Status: ${item.divisionName}",
              );
            }
          }
          // Push data to UI
          inputInspectionList.add(list ?? []);
          inputState.add(ContentState());
        },
      );
    } catch (e) {
      print("🔥 EXCEPTION OCCURRED: $e");

      inputState.add(
        ErrorState(StateRendererType.FULL_SCREEN_ERROR_STATE, e.toString()),
      );
    }
  }

  // ================================
  // 8. INPUT SINK
  // ================================
  @override
  Sink<List<InspectionStatusModel>> get inputInspectionList =>_inspectionListController.sink;

  // ================================
  // 9. OUTPUT STREAM
  // ================================
  @override
  Stream<List<InspectionStatusModel>>? get outputInspectionList => _inspectionListController.stream;
}

abstract class InspectionListViewModelInputs {
  Sink<List<InspectionStatusModel>> get inputInspectionList;
}

abstract class InspectionListViewModelOutput {
  Stream<List<InspectionStatusModel>>? get outputInspectionList;
}
