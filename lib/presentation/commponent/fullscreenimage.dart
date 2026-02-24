import 'package:flutter/material.dart';
import 'appbarcommon.dart';

class FullScreenPage extends StatelessWidget {
  final String sBeforePhoto;

  const FullScreenPage({
    super.key,
    required this.sBeforePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: () async {
        Navigator.pop(context); // force only 1 pop
        return false;
      },

      child: Scaffold(
          appBar: AppCommonAppBar(
            title: "Image View",
            showBack: true,
            onBackPressed: () {
              Navigator.pop(context); // ✅ ONE step back
            },
          ),
          body: SizedBox.expand(
            child: Image.network(
              sBeforePhoto,
              fit: BoxFit.cover,
            ),
          ),
        ),
    );
  }
}
