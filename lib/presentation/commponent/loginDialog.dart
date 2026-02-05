import 'package:citizencentric/presentation/commponent/platform_primary_button.dart';
import 'package:citizencentric/presentation/commponent/platform_text.dart';
import 'package:citizencentric/presentation/commponent/platform_textform_fields.dart';
import 'package:citizencentric/presentation/resources/color_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../login/login_viewmodel.dart';
import '../resources/assets_manager.dart';
import '../resources/platformButtonType.dart';
import '../resources/strings_manager.dart';
import '../resources/text_type.dart';
import '../resources/values_manager.dart';
import 'container_decoration.dart';
import 'decoration_image.dart';

class LoginDialogWidget extends StatelessWidget {

  final GlobalKey<FormState> formKey;
  final TextEditingController userMobileNumberController;
  final TextEditingController passwordController;
  final LoginViewModel viewModel;
  final Widget footerSection;

  const LoginDialogWidget({
    super.key,
    required this.formKey,
    required this.userMobileNumberController,
    required this.passwordController,
    required this.viewModel,
    required this.footerSection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 25),
      child: Container(
        decoration: ContainerDecoration.container(
          color: Colors.white,      // ✅ force white
          opacity: 1.0,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSize.s50),
                  // Top Image
                  Center(
                    child: Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width/2,
                      decoration: ContainerDecoration.container(
                        borderRadius: BorderRadius.circular(8),
                        backgroundImage: const DecorationImage(
                          image: AssetImage(ImageAssets.noidaParkImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.s16),
                  // Logo
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: AppImages.decoration(
                          asset: ImageAssets.noidaauthoritylogo,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.s16),
                  // Title
                  PlatformText(AppStrings.login.tr(),
                    type: AppTextType.title,
                    color: ColorManager.primary,
                  ),
                  const SizedBox(height: AppSize.s16),
                  // Mobile Number
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: PlatformTextFormField(
                      controller: userMobileNumberController,
                      label: AppStrings.mobilenumber.tr(),
                      hint: AppStrings.mobilenumber.tr(),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,       // ✅ FIXED LENGTH
                      digitsOnly: true,
                      errorText: AppStrings.mobile_no_error.tr(),
                      validationStream: viewModel.outputIsMobileNumberValid,
                      icon: Icons.phone,
                      iconColor: ColorManager.primary,
                      labelColor: ColorManager.primary,
                      onChanged: viewModel.setMobileNumber,
                    ),
                  ),

                  const SizedBox(height: AppSize.s16),
                  // Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: PlatformTextFormField(
                      controller: passwordController,
                      label: AppStrings.password.tr(),
                      // label: AppStrings.password,
                      hint: AppStrings.password.tr(),
                      //hint: AppStrings.password,
                      isPassword: true,
                      errorText: AppStrings.passwordError.tr(),
                      validationStream: viewModel.outputIsPasswordValid,
                      icon: Icons.lock,
                      iconColor: ColorManager.primary,
                      labelColor: ColorManager.primary,
                      maxLength: 20,
                      onChanged: viewModel.setPassword,
                    ),
                  ),
                  const SizedBox(height: AppSize.s16),
                  // Login Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: StreamBuilder<bool>(
                      stream: viewModel.outputIsAllInputsValid,
                      builder: (context, snapshot) {
                        return PlatformPrimaryButton(
                          label: AppStrings.login.tr(),
                          height: AppSize.s40,
                          // buttonType
                          buttonType: PlatformButtonType.stadium,
                          onPressed: (snapshot.data ?? false)
                              ? viewModel.login
                              : null,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSize.s100),
                  // Footer

                  footerSection,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// class LoginDialogWidget extends StatelessWidget {
//
//   final GlobalKey<FormState> formKey;
//   final TextEditingController userMobileNumberController;
//   final TextEditingController passwordController;
//   final LoginViewModel viewModel;
//   final Widget footerSection;
//
//   const LoginDialogWidget({
//     super.key,
//     required this.formKey,
//     required this.userMobileNumberController,
//     required this.passwordController,
//     required this.viewModel,
//     required this.footerSection,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(left: 25),
//       child: Container(
//         decoration: ContainerDecoration.container(
//           color: Colors.white,      // ✅ force white
//           opacity: 1.0,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(25),
//             bottomLeft: Radius.circular(25),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 20,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: SingleChildScrollView(
//             child: Form(
//               key: formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: AppSize.s50),
//                   // Top Image
//                   Center(
//                     child: Container(
//                       height: 25,
//                       width: MediaQuery.of(context).size.width/2,
//                       decoration: ContainerDecoration.container(
//                         borderRadius: BorderRadius.circular(8),
//                         backgroundImage: const DecorationImage(
//                           image: AssetImage(ImageAssets.noidaParkImage),
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: AppSize.s16),
//                   // Logo
//                   Center(
//                     child: Container(
//                       width: 100,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         image: AppImages.decoration(
//                           asset: ImageAssets.noidaauthoritylogo,
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: AppSize.s16),
//                   // Title
//                   PlatformText(AppStrings.login.tr(),
//                   type: AppTextType.title,
//                     color: ColorManager.primary,
//                   ),
//                   const SizedBox(height: AppSize.s16),
//                   // Mobile Number
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 28),
//                     child: PlatformTextFormField(
//                       controller: userMobileNumberController,
//                       label: AppStrings.mobilenumber.tr(),
//                       hint: AppStrings.mobilenumber.tr(),
//                       keyboardType: TextInputType.phone,
//                       maxLength: 10,       // ✅ FIXED LENGTH
//                       digitsOnly: true,
//                       errorText: AppStrings.mobile_no_error.tr(),
//                       validationStream: viewModel.outputIsMobileNumberValid,
//                       icon: Icons.phone,
//                       iconColor: ColorManager.primary,
//                       labelColor: ColorManager.primary,
//                       onChanged: viewModel.setMobileNumber,
//                     ),
//                   ),
//
//                   const SizedBox(height: AppSize.s16),
//                   // Password
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 28),
//                     child: PlatformTextFormField(
//                       controller: passwordController,
//                       label: AppStrings.password.tr(),
//                      // label: AppStrings.password,
//                       hint: AppStrings.password.tr(),
//                       //hint: AppStrings.password,
//                       isPassword: true,
//                       errorText: AppStrings.passwordError.tr(),
//                       validationStream: viewModel.outputIsPasswordValid,
//                       icon: Icons.lock,
//                       iconColor: ColorManager.primary,
//                       labelColor: ColorManager.primary,
//                       maxLength: 20,
//                       onChanged: viewModel.setPassword,
//                     ),
//                   ),
//                   const SizedBox(height: AppSize.s16),
//                   // Login Button
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 28),
//                     child: StreamBuilder<bool>(
//                       stream: viewModel.outputIsAllInputsValid,
//                       builder: (context, snapshot) {
//                         return PlatformPrimaryButton(
//                           label: AppStrings.login.tr(),
//                           height: AppSize.s40,
//                           // buttonType
//                           buttonType: PlatformButtonType.stadium,
//                           onPressed: (snapshot.data ?? false)
//                               ? viewModel.login
//                               : null,
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: AppSize.s100),
//                   // Footer
//
//                   footerSection,
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }