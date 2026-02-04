import 'package:citizencentric/presentation/commponent/platform_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/text_type.dart';


class AppCommonAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final List<Widget>? actions;

  // 🔹 NEW OPTIONS
  final bool showBack;
  final VoidCallback? onBackPressed;

  const AppCommonAppBar({
    Key? key,
    required this.title,
    this.centerTitle = true,
    this.actions,
    this.showBack = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorManager.primary,
      elevation: 0,
      centerTitle: centerTitle,

      // 🔹 GENERIC LEADING BACK ICON
      leading: showBack
          ? IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
        onPressed: onBackPressed ??
                () {
              Navigator.pop(context);
            },
      )
          : null,

      iconTheme: const IconThemeData(
        color: Colors.white,
      ),

      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: PlatformText(
          title,
          type: AppTextType.title,
          color: Colors.white,
        ),
      ),

      actions: actions,

      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: ColorManager.primary,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


// class AppCommonAppBar extends StatelessWidget
//     implements PreferredSizeWidget {
//   final String title;
//   final bool centerTitle;
//   final List<Widget>? actions;
//
//   const AppCommonAppBar({
//     Key? key,
//     required this.title,
//     this.centerTitle = true,
//     this.actions,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//      // backgroundColor: Colors.transparent, // required for gradient
//       backgroundColor: ColorManager.primary,
//       elevation: 0,
//       centerTitle: centerTitle,
//       iconTheme: const IconThemeData(
//         color: Colors.white,
//       ),
//       title: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5),
//         child: PlatformText(
//           AppStrings.noidapark.tr(),
//           type: AppTextType.title,
//           color: Colors.white,
//         ),
//         // child: Text(
//         //   title,
//         //   textAlign: TextAlign.center,
//         //   style: const TextStyle(
//         //     color: Colors.white,
//         //     fontSize: 16,
//         //     fontWeight: FontWeight.normal,
//         //     fontFamily: 'Montserrat',
//         //   ),
//         // ),
//       ),
//       actions: actions,
//       flexibleSpace: Container(
//         decoration:  BoxDecoration(
//           color: ColorManager.primary
//           // gradient: LinearGradient(
//           //   colors: [
//           //     Color(0xFF4CAF50), // Fresh Leaf Green
//           //     Color(0xFF81C784), // Soft Mint Green
//           //   ],
//           //   begin: Alignment.topLeft,
//           //   end: Alignment.bottomRight,
//           // ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
