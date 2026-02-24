import 'dart:async';

import 'package:citizencentric/presentation/base/baseviewmodel.dart';
import 'package:citizencentric/presentation/common/freezed_data_classes.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../domain/usecase/change_password_usecase.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../common/state_renderer/state_renderer.dart';
import '../commponent/toast_utilit.dart';

class ChangePasswordUiModel extends BaseViewModel implements ChangePasswordUiModelInputs,ChangePasswordUiModelOutputs {

  /// todo here i will create a viewModel of the change Password

  StreamController _oldPasswordStreamController = StreamController<String>.broadcast();
  StreamController _newPasswordStreamController = StreamController<String>.broadcast();
  StreamController _confirmPasswordStreamController = StreamController<String>.broadcast();
  StreamController _isAllInputsValidStreamController = StreamController<void>.broadcast();
  StreamController isUserLoggedInSuccessfullyStreamController = StreamController<bool>.broadcast();


  // ChangePasswordObject

  //final hardUserId = "14";/// todo here you convert into a real userID Fetch a local database and used

  var changePasswordObject = ChangePasswordObject(
    sOldPassword: '',
    sNewPassword: '',
    iUserId: ''
  );

  ChangPasswordUseCase  _changePassWordUseCase;
  ChangePasswordUiModel(this._changePassWordUseCase);
  var msg;

  // input part
  AppPreferences appPreferences = instance<AppPreferences>();

  @override
  void start() {
    // start a loading
    inputState.add(ContentState());
  }

  @override
  void dispose() {

    _oldPasswordStreamController.close();
    _newPasswordStreamController.close();
    _confirmPasswordStreamController.close();
    _isAllInputsValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
    super.dispose();
  }

  @override
  changePassword() async {
    print("------ changePassword api call ------");

    final userData = await appPreferences.getLoginUserData();
    final userId = "${userData?['userId']}";

    /// 🔹 SHOW LOADING
    inputState.add(
      LoadingState(
        stateRendererType: StateRendererType.POPUP_LOADING_STATE,
      ),
    );

    (await _changePassWordUseCase.execute(
      ChangePassWordInput(
        changePasswordObject.sOldPassword,
        changePasswordObject.sNewPassword,
        userId,
      ),
    ))
        .fold(
      /// ❌ FAILURE
          (failure) {
        inputState.add(
          ErrorState(
            StateRendererType.POPUP_ERROR_STATE,
            failure.message,
          ),
        );
      },

      /// ✅ SUCCESS
          (data) async {
        /// 🔹 CLOSE LOADING POPUP
        inputState.add(ContentState());

        if (data.Result == "1") {
          /// 🔹 OPTIONAL: show toast
          showToast(data.Msg);

          /// 🔹 CLEAR LOGIN DATA (IMPORTANT)
          await appPreferences.logout();

          /// 🔹 TRIGGER NAVIGATION EVENT (BEST PRACTICE)
          //isUserLoggedInSuccessfullyStreamController.add("LOGOUT");
          isUserLoggedInSuccessfullyStreamController.add(true);
        } else {
          inputState.add(
            ErrorState(
              StateRendererType.POPUP_ERROR_STATE,
              data.Msg,
            ),
          );
        }
      },
    );
  }

  // changePassword() async {
  //   {
  //     print("------51-----changePassword api call------");
  //     final userData = await appPreferences.getLoginUserData();
  //     var userId = "${userData?['userId']}";
  //     print("-----60----userID ---$userId");
  //     inputState.add(
  //         LoadingState(stateRendererType:StateRendererType.POPUP_LOADING_STATE));
  //     (await _changePassWordUseCase.execute(
  //         ChangePassWordInput(
  //             changePasswordObject.sOldPassword,
  //             changePasswordObject.sNewPassword,
  //             userId,
  //         ))).fold(
  //             (failure)=>{
  //           // left -falure
  //           //print('-------failed-------'),
  //           // print(failure.message)
  //           inputState.add(ErrorState(
  //               StateRendererType.POPUP_ERROR_STATE, failure.message))
  //         },
  //          (data) {
  //           // right - Success data
  //           // here you get a data from a model carefully chose a model
  //           //print("success --Get data ----xx ${data.firstName}")
  //          // inputState.add(ContentState());
  //            var result = "${data.Result}";
  //            if(result=="1"){
  //              msg = "${data.Msg}";
  //              inputState.add(SuccessState("Password Change"));
  //              // to navigate login page
  //              Navigator.pushReplacementNamed(context, Routes.loginRoute);
  //
  //
  //            }else{
  //              inputState.add(ErrorState(
  //                  StateRendererType.POPUP_ERROR_STATE, msg));
  //            }
  //
  //           // navigate the main screen after login
  //           isUserLoggedInSuccessfullyStreamController.add(true);
  //         });
  //   }
  //
  // }
  @override
  setOldPassword(String oldPassword) {
    print("----79----oldpassword---$oldPassword");
    inputOldPassword.add(oldPassword);
    changePasswordObject = changePasswordObject.copyWith(sOldPassword: oldPassword);
    _validate();

  }

  @override
  setNewPassword(String newPassword) {
    print("----88----newpassword---$newPassword");
    inputNewPassword.add(newPassword);// Add data from a ui
    changePasswordObject = changePasswordObject.copyWith(sNewPassword: newPassword);
    _validate();
  }

  @override
  setConfirmPassword(String confirmPassword) {
    print("----96----Confirm Password---$confirmPassword");
    //  here you pass hard value as a userId After that you make a dynamic.
     inputConfirmPassword.add(confirmPassword);// add data to ui
    // changePasswordObject = changePasswordObject.copyWith(iUserId: confirmPassword);
    changePasswordObject = changePasswordObject.copyWith(iUserId:confirmPassword);//new password
    // _validate();
  }

  // output parts

  @override
  Sink get inputOldPassword => _oldPasswordStreamController.sink;

  @override
  Sink get inputNewPassword => _newPasswordStreamController.sink;

  @override
  Sink get inputConfirmPassword => _confirmPasswordStreamController.sink;

  Sink get inputIsAllInputValid => _isAllInputsValidStreamController.sink;

  // output

  @override
  // TODO: implement outputIsOldPasswordValid
  Stream<bool> get outputIsOldPasswordValid => _oldPasswordStreamController.stream.map((oldPassword) => _isOldPasswordValid(oldPassword));

  @override
  // TODO: implement outputIsNewPasswordValid
  Stream<bool> get outputIsNewPasswordValid => _newPasswordStreamController.stream.map((newPassword) => _isNewPasswordValid(newPassword));

   @override
  // TODO: implement outputIsConfirmPasswordValid
  Stream<bool> get outputIsConfirmPasswordValid => _confirmPasswordStreamController.stream.map((confirmPassword) => _isConfirmPasswordValid(confirmPassword));

  Stream<bool> get outputIsAllInputsValid => _isAllInputsValidStreamController.stream.map((_)=>_isAllInputsValid());

// private function

 _isOldPasswordValid(String oldPassword){
   return oldPassword.isNotEmpty;
 }
 _isNewPasswordValid(String newPassword) {
   return newPassword.isNotEmpty;
 }
 _isConfirmPasswordValid(String confirmPassword){
   return confirmPassword.isNotEmpty;
 }

  _validate() {
    inputIsAllInputValid.add(null);
  }

  bool _isAllInputsValid() {
    return _isOldPasswordValid(
        changePasswordObject.sOldPassword) &&
        _isNewPasswordValid(changePasswordObject.sNewPassword);

  }
}
abstract class ChangePasswordUiModelInputs{
   // four functions for actions
  setOldPassword(String oldPassword);
  setNewPassword(String newPassword);
  setConfirmPassword(String confirmPassword);
  changePassword();
  // three sinks for streams
  Sink get inputOldPassword;
  Sink get inputNewPassword;
  Sink get inputConfirmPassword;
  Sink get inputIsAllInputValid;


}
abstract class ChangePasswordUiModelOutputs{
   // three sink
   Stream<bool> get outputIsOldPasswordValid;
   Stream<bool> get outputIsNewPasswordValid;
   Stream<bool> get outputIsConfirmPasswordValid;
   Stream<bool> get outputIsAllInputsValid;

}
