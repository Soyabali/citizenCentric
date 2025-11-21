
import 'package:citizencentric/presentation/common/state_renderer/state_render_impl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import 'change_password_ui_model.dart';


class ChangePassword extends StatefulWidget {

  const ChangePassword({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();

}

class _LoginViewState extends State<ChangePassword> {

  ChangePasswordUiModel _viewModel = instance<ChangePasswordUiModel>();
  AppPreferences _appPreferences = instance<AppPreferences>();

  TextEditingController _userOldPassword = TextEditingController();
  TextEditingController _userNewPassword = TextEditingController();
  TextEditingController _userConfirmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  _bind() {
    _viewModel.start();
    _userOldPassword.addListener(() => _viewModel.setOldPassword(_userOldPassword.text));
    _userNewPassword.addListener(() => _viewModel.setNewPassword(_userNewPassword.text));
    _userConfirmPassword.addListener(() => _viewModel.setConfirmPassword(_userConfirmPassword.text));

    _viewModel.isUserLoggedInSuccessfullyStreamController.stream.listen((isSuccessLoggedIn) {

      // SchedulerBinding.instance.addPostFrameCallback((_){
      //   _appPreferences.setIsUserLoggedIn();
      //   Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
      // });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _appPreferences.setIsUserChangePassword();
        Navigator.of(context).pushReplacementNamed(Routes.loginRoute);

      });

    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return _getContentWidget();
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder(
          stream: _viewModel.outputState,
          builder: (context,snapshot){
            return snapshot.data?.getScreenWidget(context,_getContentWidget(),()
            {
              _viewModel.changePassword();
            }) ?? _getContentWidget();
          }),
    );
  }

  Widget _getContentWidget() {
    //return Scaffold(
    //backgroundColor: ColorManager.white,
    return Container(
        padding: EdgeInsets.only(top: AppPadding.p100),
        color: ColorManager.white,
        child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Image(image: AssetImage(ImageAssets.splashLogo)),
                  ),

                  SizedBox(height: AppSize.s28),
                  Padding(
                    padding: EdgeInsets.only(
                        left: AppPadding.p28,
                        right: AppPadding.p28),
                    child: StreamBuilder<bool>(
                      stream: _viewModel.outputIsOldPasswordValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: _userOldPassword,
                          decoration: InputDecoration(
                              hintText: AppStrings.mobilenumber.tr(),
                              labelText: AppStrings.mobilenumber.tr(),
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.usernameError.tr()),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: AppSize.s28),
                  Padding(
                    padding: EdgeInsets.only(
                        left: AppPadding.p28,
                        right: AppPadding.p28),
                    child: StreamBuilder<bool>(
                      stream: _viewModel.outputIsNewPasswordValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: _userNewPassword,
                          decoration: InputDecoration(
                              hintText: AppStrings.oldpassword.tr(),
                              labelText: AppStrings.oldpassword.tr(),
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.usernameError.tr()),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: AppSize.s28),
                  Padding(
                    padding: EdgeInsets.only(
                        left: AppPadding.p28,
                        right: AppPadding.p28),
                    child: StreamBuilder<bool>(
                      stream: _viewModel.outputIsConfirmPasswordValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: _userConfirmPassword,
                          decoration: InputDecoration(
                              hintText: AppStrings.conformpassword.tr(),
                              labelText: AppStrings.conformpassword.tr(),
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.usernameError.tr()),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: AppSize.s28),
                  Padding(
                      padding: EdgeInsets.only(
                          left: AppPadding.p28, right: AppPadding.p28),
                      child: StreamBuilder<bool>(
                        stream: _viewModel.outputIsAllInputsValid,
                        builder: (context, snapshot) {
                          return SizedBox(
                            width: double.infinity,
                            height: AppSize.s40,
                            child: ElevatedButton(
                                onPressed: (snapshot.data ?? false)
                                    ? (){
                                  print('changePassword pressed with ${_viewModel.changePasswordObject}');
                                  _viewModel.changePassword();
                                }
                                    : null,
                                child: Text(AppStrings.changePassword).tr()),
                          );

                        },
                      )),


                ],
              ),
            )
        )
    );

  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
