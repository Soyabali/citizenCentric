import 'dart:async';

import 'package:citizencentric/domain/usecase/staffList_usecase.dart';
import 'package:citizencentric/presentation/base/baseviewmodel.dart';
import 'package:citizencentric/presentation/common/state_renderer/state_render_impl.dart';
import 'package:citizencentric/presentation/common/state_renderer/state_renderer.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/model/model.dart';
import '../../common/freezed_data_classes.dart';

class HomeViewModel extends BaseViewModel implements HomeViewModelInputs,HomeViewModelOutputs {

  // StaffListUsecase
  StaffListUseCase _staffListUseCase;
  StreamController _bannersStreamController = BehaviorSubject<List<StaffListModel>>();
  StreamController _serviceStreamController = BehaviorSubject<List<StaffListModel>>();
  StreamController _storeStreamController = BehaviorSubject<List<StaffListModel>>();
  HomeViewModel(this._staffListUseCase);

  // StaffListObject
  var stfffListObject = StaffListObject(
      sEmpCode: "",
  );

  @override
  void start() {
   _getHome(); // call a api in a model
  }


  // Api implementation in a model
  _getHome() async {
    inputState.add(LoadingState(stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));
    // Note here in this api if i dont any input then api give a response
    // here i dont pass any argument i only give a StaffListInput but not any
    // argument in this class, if you need then you should entr
    // as a login api
    (await _staffListUseCase.execute(StaffListInput(""))).fold(
        (failure) {
          inputState.add(ErrorState(StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
        },(list){
          inputState.add(ContentState());
          // carefully this is depend you response how to manage respnse
          // according to response you shuld manage here
          inputBanners.add(list);
          inputServices.add(list);
          inputStores.add(list);
    });
    {

    }
  }
  @override
  void dispose() {
    _bannersStreamController.close();
    _serviceStreamController.close();
    _storeStreamController.close();
  }
   //  Input Part

  @override
  Sink get inputBanners => _bannersStreamController.sink;

  @override
  Sink get inputServices => _serviceStreamController.sink;

  @override
  Sink get inputStores => _storeStreamController.sink;

  // OutPut Part
  @override
  Stream<List<StaffListModel>> get outputBanners => _bannersStreamController.stream.map((banners) => banners);
  @override
  Stream<List<StaffListModel>> get outputServices =>  _serviceStreamController.stream.map((services) => services);
  @override
  Stream<List<StaffListModel>> get outputStores => _storeStreamController.stream.map((stores) => stores);
}
abstract class HomeViewModelInputs {
  Sink get inputStores;
  Sink get inputServices;
  Sink get inputBanners;
}
abstract class HomeViewModelOutputs{

  Stream<List<StaffListModel>> get outputStores;

  Stream<List<StaffListModel>> get outputServices;

  Stream<List<StaffListModel>> get outputBanners;
}