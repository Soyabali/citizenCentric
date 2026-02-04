import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommonShimmerList extends StatelessWidget {
  final int itemCount;
  final double avatarSize;
  final double titleHeight;
  final double trailingSize;
  final EdgeInsets dividerPadding;

  const CommonShimmerList({
    Key? key,
    this.itemCount = 6,
    this.avatarSize = 35,
    this.titleHeight = 14,
    this.trailingSize = 12,
    this.dividerPadding =
    const EdgeInsets.symmetric(horizontal: 12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              leading: _shimmerBox(
                width: avatarSize,
                height: avatarSize,
                radius: 5,
              ),
              title: _shimmerBox(
                width: double.infinity,
                height: titleHeight,
              ),
              trailing: _shimmerBox(
                width: trailingSize,
                height: trailingSize,
              ),
            ),
            Padding(
              padding: dividerPadding,
              child: Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    double radius = 0,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
