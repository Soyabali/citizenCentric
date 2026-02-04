import 'package:citizencentric/presentation/commponent/platform_text.dart';
import 'package:citizencentric/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../resources/text_type.dart';
import 'container_decoration.dart';

class PlatformFooter extends StatelessWidget {
  final String poweredByText;
  final String companyName;
  final String logoAsset;
  final double textSize;
  final Color? textColor;
  final Color? dividerColor;
  final double logoSize;

  const PlatformFooter({
    super.key,
    required this.poweredByText,
    required this.companyName,
    required this.logoAsset,
    this.textSize = 12,
    this.textColor,
    this.dividerColor,
    this.logoSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false, // 👈 important
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8), // 👈 control bottom space
        child: Column(
          mainAxisSize: MainAxisSize.min, // 👈 avoids extra height
          children: [
            /// 🔹 Powered By Row
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          '*',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF4B9C91),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Divider(
                          color: dividerColor ?? Colors.grey[400],
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: PlatformText(
                    AppStrings.powerd_by.tr(),
                    type: AppTextType.subtitle,
                  ),
                ),

                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: dividerColor ?? Colors.grey[400],
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          '*',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF4B9C91),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔹 Company name + logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlatformText(
                  AppStrings.companyName.tr(),
                  type: AppTextType.subtitle,
                  color: const Color(0xFFf37339),
                ),
                const SizedBox(width: 8),
                Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: ContainerDecoration.container(
                    borderRadius: BorderRadius.circular(4),
                    backgroundImage: DecorationImage(
                      image: AssetImage(logoAsset),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class PlatformFooter extends StatelessWidget {
//   final String poweredByText;
//   final String companyName;
//   final String logoAsset;
//   final double textSize;
//   final Color? textColor;
//   final Color? dividerColor;
//   final double logoSize;
//
//   const PlatformFooter({
//     super.key,
//     required this.poweredByText,
//
//     required this.companyName,
//     required this.logoAsset,
//     this.textSize = 12,
//     this.textColor,
//     this.dividerColor,
//     this.logoSize = 20,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // 🔹 Powered By Row with Dividers
//         Row(
//           children: [
//             // 🔹 Left line with starting star
//             Expanded(
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8),
//                     child: const Text(
//                       '*',
//                       style: TextStyle(fontSize: 20,
//                         color: Color(0xFF4B9C91)
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Divider(
//                       color: dividerColor ?? Colors.grey[400],
//                       thickness: 1,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // 🔹 Center text
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: PlatformText(
//                 AppStrings.powerd_by.tr(),
//                 type: AppTextType.subtitle,
//               ),
//             ),
//
//             // 🔹 Right line with ending star
//             Expanded(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Divider(
//                       color: dividerColor ?? Colors.grey[400],
//                       thickness: 1,
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8),
//                     child: const Text(
//                       '*',
//                       style: TextStyle(fontSize: 20,
//                       color: Color(0xFF4B9C91)
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         // 🔹 Company Name + Logo
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // class a textView
//             PlatformText(
//               AppStrings.companyName.tr(),
//               type: AppTextType.subtitle,
//               color: const Color(0xFFf37339)
//             ),
//             // 4b9c91
//             const SizedBox(width: 8),
//             Container(
//               width: logoSize,
//               height: logoSize,
//               decoration: ContainerDecoration.container(
//                 borderRadius: BorderRadius.circular(4),
//                 backgroundImage: DecorationImage(
//                   image: AssetImage(logoAsset),
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }