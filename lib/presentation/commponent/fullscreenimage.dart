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


// class FullScreenPage extends StatelessWidget {
//   final String sBeforePhoto;
//
//   const FullScreenPage({
//     super.key,
//     required this.sBeforePhoto,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false, // ⛔ Blocks Android back + iOS swipe back
//       child: Scaffold(
//         appBar: AppCommonAppBar(
//           title: "Image View",
//           showBack: true,
//           onBackPressed: () {
//             // ✅ Only allowed back
//             Navigator.pop(context);
//           },
//         ),
//         body: SizedBox.expand(
//           child: Image.network(
//             sBeforePhoto,
//             fit: BoxFit.cover, // 👈 fills entire body
//           ),
//         ),
//       ),
//     );
//   }
// }



// class FullScreenPage extends StatelessWidget {
//   final String sBeforePhoto;
//
//   const FullScreenPage({
//     super.key,
//     required this.sBeforePhoto,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false, // ⛔ block default system pop
//       onPopInvoked: (didPop) {
//         if (!didPop) {
//           Navigator.pop(context); // ✅ always go back ONE step
//         }
//       },
//       child: Scaffold(
//         appBar: AppCommonAppBar(
//           title: "Image View",
//           showBack: true,
//           onBackPressed: () {
//             Navigator.pop(context); // AppBar back
//           },
//         ),
//         body: Stack(
//           children: [
//             sBeforePhoto.isNotEmpty
//                 ? Image.network(
//               sBeforePhoto,
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: double.infinity,
//             )
//                 : const Center(
//               child: Text(
//                 "No Image",
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FullScreenPage extends StatelessWidget {
//
//   final sBeforePhoto;
//
//   const FullScreenPage({super.key,required this.sBeforePhoto});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:AppCommonAppBar(
//         title: "Image View", // title: "Park Geotagging",
//         showBack: true,
//         onBackPressed: () {
//           print("Back pressed");
//           Navigator.pop(context);
//         },
//       ),
//       body: Stack(
//         children: [
//           sBeforePhoto != null && sBeforePhoto.isNotEmpty
//               ? Image.network(
//             sBeforePhoto,
//             fit: BoxFit.cover,
//             width: double.infinity,
//             height: double.infinity,
//             errorBuilder: (context, error, stackTrace) {
//               return const Center(
//                 child: Text(
//                   "No Image",
//                   style: TextStyle(fontSize: 18, color: Colors.black),
//                 ),
//               );
//             },
//           )
//               : const Center(
//             child: Text(
//               "No Image",
//               style: TextStyle(fontSize: 18, color: Colors.black),
//             ),
//           ),
//
//           // Close button
//           // Positioned(
//           //   top: 5.0,
//           //   right: 10.0,
//           //   child: IconButton(
//           //     icon: const Icon(Icons.close, color: Colors.red,size: 50),
//           //     onPressed: () {
//           //       Navigator.pop(context);
//           //     },
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
