import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../commponent/background_image.dart';
import '../resources/assets_manager.dart';
import '../resources/strings_manager.dart';
import '_actionCard.dart';

class HomeHeaderStack extends StatelessWidget {
  final VoidCallback onDashboardTap;
  final VoidCallback onPostInspectionTap;

  const HomeHeaderStack({
    super.key,
    required this.onDashboardTap,
    required this.onPostInspectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290,
      child: Stack(
        children: [
          // 🔹 Background Container
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(
                //   color: Colors.grey.shade300,
                //   width: 2,
                // ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 220,
                    child: BackgroundImage(
                      imagePath: ImageAssets.homepageheader,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),

          // 🔹 Floating Cards
          Positioned(
            top: 165,
            left: 20,
            right: 20,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.2),
                //     blurRadius: 8,
                //     offset: const Offset(0, 4),
                //   ),
                // ],
              ),
              child: Row(
                children: [
                  ActionCard(
                    image: ImageAssets.ic_served_points,
                    title: AppStrings.dashboard.tr(),
                    onTap: onDashboardTap,
                  ),
                  ActionCard(
                    image: ImageAssets.ic_create_points,
                    title: AppStrings.postInspection.tr(),
                    onTap: onPostInspectionTap,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
