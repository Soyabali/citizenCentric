import 'dart:async';

import 'package:citizencentric/domain/usecase/login_usecase.dart';
import 'package:citizencentric/presentation/base/baseviewmodel.dart';
import 'package:citizencentric/presentation/common/freezed_data_classes.dart';
import 'package:citizencentric/presentation/common/state_renderer/state_renderer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../common/state_renderer/state_render_impl.dart';

class LoginViewModel extends BaseViewModel implements LoginViewModelInputs,LoginViewModelOutputs {

  StreamController _userMobileNumberStreamController = StreamController<String>.broadcast();
  StreamController _userPasswordStreamController = StreamController<String>.broadcast();
  StreamController _isAllInputsValidStreamController = StreamController<void>.broadcast();
  StreamController isUserLoggedInSuccessfullyStreamController = StreamController<String>();
  AppPreferences _appPreferences = instance<AppPreferences>();

  //var loginObject = LoginObject("","");

  bool _showedErrorOnce = false;
  bool _isLoginAction = false;
  bool _isDialogShowing = false;
  bool _isTyping = false;

  var loginObject = LoginObject(
        userMobileNumber: "",
        password: "",
        appVersion: ""
  );

LoginUseCase _loginUseCase;
LoginViewModel(this._loginUseCase);

  @override
  void start() {
    // TODO: implement start
    inputState.add(ContentState());
  }


  // toast code
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
      LoadingState(
        stateRendererType: StateRendererType.POPUP_LOADING_STATE,
      ),
    );

    (await _loginUseCase.execute(
      LoginUseCaseInput(
        loginObject.userMobileNumber,
        loginObject.password,
        loginObject.appVersion,
      ),
    ))
        .fold(

      /// ❌ FAILURE → SHOW ERROR DIALOG
          (failure) {
            // show a toast
            showToast("This contact number not registered with us");
        // inputState.add(
        //   ErrorState(
        //     StateRendererType.POPUP_ERROR_STATE,
        //     failure.message,
        //   ),
        // );

        Future.delayed(const Duration(milliseconds: 300), () {
          inputState.add(ContentState());
        });
      },

      /// ✅ SUCCESS → DIRECT NAVIGATION
          (data) async {
            // -----here you may be see dialog
           // inputState.add(SuccessState('Login Sucess'));
        // 🔹 remove loading popup
        inputState.add(ContentState());


        // 🔹 trigger navigation
        print("I UserID :  ${data.userId}");
        print(" Name :  ${data.name}");
        print(" ContactNo :  ${data.contactNo}");
        print(" DesnName :  ${data.designationName}");
        print(" IDesignCode :  ${data.designationCode}");
        print(" IDeputyCode :  ${data.departmentCode}");
        print(" I UserCode :  ${data.userTypeCode}");
        print(" token :  ${data.token}");
        print(" token :  ${data.token}");
        print(" dLsstLoginAt :  ${data.lastLoginAt}");
        print(" iAgencyCode :  ${data.agencyCode}");
        // 🔹 Save login details
        await _appPreferences.setLoginUserData(
          userId: data.userId,
          name: data.name,
          contactNo: data.contactNo,
          designationName: data.designationName,
          designationCode: data.designationCode,
          departmentCode: data.departmentCode,
          userTypeCode: data.userTypeCode,
          lastLoginAt: data.lastLoginAt,
          agencyCode: data.agencyCode,
        );

        //dLastLoginAt
        isUserLoggedInSuccessfullyStreamController.add(data.token);

        },
    );
  }

  @override
  setMobileNumber(String mobileNumber) {// to take mobile no ui screen
    _isTyping = true;
    inputMobileNumber.add(mobileNumber);// here get a mobile no to put int sink (inputMobileNumber)
    loginObject = loginObject.copyWith(userMobileNumber: mobileNumber);// to give mobile from ui and give  loginObject that take
    _validate();
    // Reset typing flag after a short delay
    Future.delayed(Duration(milliseconds: 500), () {
      _isTyping = false;
    });
    //loginObject = loginObject.copyWith(mobileNumber: mobileNumber);
  }
  @override
  setPassword(String password) {// to take password from a ui file
    _isTyping = true;
    inputPassword.add(password);// here pass password to sink (inputPassword)
    loginObject = loginObject.copyWith(password: password);// to pass get data from a ui to loginObject
    _validate();
    // Reset typing flag after a short delay
    Future.delayed(Duration(milliseconds: 500), () {
      _isTyping = false;
    });
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

  // bool _isMobileNumberValid(String userName) {
  //   return userName.isNotEmpty;
  // }
  bool _isMobileNumberValid(String mobile) {
    final trimmed = mobile.trim();

    // 1️⃣ Must be exactly 10 digits
    if (!RegExp(r'^\d{10}$').hasMatch(trimmed)) {
      return false;
    }

    // 2️⃣ First digit must be between 6–9
    if (!RegExp(r'^[6-9]').hasMatch(trimmed)) {
      return false;
    }

    // 3️⃣ Reject numbers where all digits are same (e.g. 0000000000)
    if (RegExp(r'^(\d)\1{9}$').hasMatch(trimmed)) {
      return false;
    }

    return true;
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
