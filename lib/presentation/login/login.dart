
import 'package:citizencentric/presentation/common/state_renderer/state_render_impl.dart';
import 'package:citizencentric/presentation/login/login_viewmodel.dart';
import 'package:citizencentric/presentation/resources/assets_manager.dart';
import 'package:citizencentric/presentation/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../commponent/background_image.dart';
import '../commponent/loginDialog.dart';
import '../commponent/platformfooter.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../riverpod/main_view_controller..dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  @override

  _LoginViewState createState() => _LoginViewState();

}

class _LoginViewState extends ConsumerState<LoginView> {

  LoginViewModel _viewModel = instance<LoginViewModel>();
  AppPreferences _appPreferences = instance<AppPreferences>();

  // Controller
  TextEditingController _userMobileNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // key
  final _formKey = GlobalKey<FormState>();

  void _bind() {
    _viewModel.start();
    _viewModel.isUserLoggedInSuccessfullyStreamController.stream.listen((token) async {
      if (!mounted) return;
      // 🔹 ensure dialog is fully dismissed
      await Future.delayed(const Duration(milliseconds: 100));
      _appPreferences.setIsUserLoggedIn();
      // Acctully token get a model and store in a sharedPreference this is a most
      // important concept to store a token
      print("-----xxxxxxx------------token-------$token");
      _appPreferences.setUserToken(token);
      resetModules();
      // this is a concept of riverpod ref
      ref.read(mainViewProvider.notifier).changeIndex(0);
      if (!mounted) return;
      //Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
      Navigator.of(context).pushReplacementNamed(Routes.homePage);
    });
  }

  @override
  void initState() {
    // here you should call a isolate to call a _bind() function every where in a application.
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,

      body: Stack(
        children: [
          // 🔹 Background layers
          Column(
            children: [
              // 🔹 Top 35% Image
              Expanded(
                flex: 40,
                child: BackgroundImage(
                  imagePath: ImageAssets.backgroundImage,
                  fit: BoxFit.cover,
                ),
              ),
              // 🔹 Bottom 65% Color
              Expanded(
                flex: 65,
                child: Container(
                  color: const Color(0xFF4B9C91),
                ),
              ),
            ],
          ),
          // 🔹 Your existing content (NO CHANGE)
          StreamBuilder(
            stream: _viewModel.outputState,
            builder: (context, snapshot) {
              return snapshot.data?.getScreenWidget(
                context,
                _getContentWidget(),
                    () {
                  _viewModel.login();
                },
              ) ??
              _getContentWidget();
            },
          ),
        ],
      ),
    );
  }

  Widget _getContentWidget() {
    return GestureDetector(
      onTap: () {
        // Unfocus all text fields when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
       // padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40), // root padding
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top spacing
                SizedBox(height: 80),
                // Login dialog
                LoginDialogWidget(
                  formKey: _formKey,
                  userMobileNumberController: _userMobileNumberController,
                  passwordController: _passwordController,
                  viewModel: _viewModel,
                  footerSection: PlatformFooter(
                    companyName: AppStrings.companyName,
                    logoAsset: ImageAssets.favicon,
                    textColor: Colors.grey[400],
                    dividerColor: Colors.grey[600], poweredByText: '',
                  ),
                ),
                // Flexible spacing at the bottom if needed
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







