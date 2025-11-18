import 'dart:async';

import 'package:citizencentric/domain/usecase/login_usecase.dart';
import 'package:citizencentric/presentation/base/baseviewmodel.dart';
import 'package:citizencentric/presentation/common/freezed_data_classes.dart';
import 'package:citizencentric/presentation/common/state_renderer/state_renderer.dart';
import '../common/state_renderer/state_render_impl.dart';

class LoginViewModel extends BaseViewModel implements LoginViewModelInputs,LoginViewModelOutputs {

  StreamController _userMobileNumberStreamController = StreamController<String>.broadcast();
  StreamController _userPasswordStreamController = StreamController<String>.broadcast();
  StreamController _isAllInputsValidStreamController = StreamController<void>.broadcast();
  StreamController isUserLoggedInSuccessfullyStreamController = StreamController<bool>();

  //var loginObject = LoginObject("","");
  bool _showedErrorOnce = false;

  var loginObject = LoginObject(
        userMobileNumber: "",
        password: "",
  );

LoginUseCase _loginUseCase;
LoginViewModel(this._loginUseCase);

  @override
  void start() {
    // TODO: implement start
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _userMobileNumberStreamController.close();
    _userPasswordStreamController.close();
    _isAllInputsValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }
  // inputpart

  @override
  Sink get inputMobileNumber => _userMobileNumberStreamController.sink;// this is way to put data into the stream
  Sink get inputPassword => _userPasswordStreamController.sink;
  Sink get inputIsAllInputValid => _isAllInputsValidStreamController.sink;


  @override
  login() async {
    inputState.add(
        LoadingState(stateRendererType:StateRendererType.POPUP_LOADING_STATE));
        (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.userMobileNumber,loginObject.password))).fold(
        (failure)=>{
          // left -falure
          //print('-------failed-------'),
         // print(failure.message)
          inputState.add(ErrorState(
              StateRendererType.POPUP_ERROR_STATE, failure.message))
        },
        (data) {
          // right - Success data
          // here you get a data from a model carefully chose a model
          //print("success --Get data ----xx ${data.firstName}")
           inputState.add(ContentState());
           // navigate the main screen after login
           isUserLoggedInSuccessfullyStreamController.add(true);
        });
  }

  @override
  setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
    loginObject = loginObject.copyWith(userMobileNumber: mobileNumber);
    _validate();
    //loginObject = loginObject.copyWith(mobileNumber: mobileNumber);
  }
  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    _validate();
  }
  // output part
  @override
  // TODO: implement outputIsMobileNumberValid
  Stream<bool> get outputIsMobileNumberValid => _userMobileNumberStreamController.stream.map((mobileNumber)=>_isMobileNumberValid(mobileNumber));

  @override
  // TODO: implement outputIsPasswordValid
  Stream<bool> get outputIsPasswordValid => _userPasswordStreamController.stream.map((password)=>_isPasswordValid(password));
  @override
  // TODO: implement outputIsAllInputsValid
  Stream<bool> get outputIsAllInputsValid => _isAllInputsValidStreamController.stream.map((_)=>_isAllInputsValid());

  // create a private function for a  Validaton
  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isMobileNumberValid(String userName) {
    return userName.isNotEmpty;
  }
  _validate() {
    inputIsAllInputValid.add(null);
  }

  bool _isAllInputsValid() {
    return _isMobileNumberValid(loginObject.userMobileNumber) && _isPasswordValid(loginObject.password);
  }

 }
abstract class LoginViewModelInputs {
  // three functions for actions
  setMobileNumber(String mobileNumber);
  setPassword(String password);
  login();
  // two sinks for streams
  Sink get inputMobileNumber;
  Sink get inputPassword;
  Sink get inputIsAllInputValid;
}
abstract class LoginViewModelOutputs {
  Stream<bool> get outputIsMobileNumberValid;
  Stream<bool> get outputIsPasswordValid;
  Stream<bool> get outputIsAllInputsValid;

}