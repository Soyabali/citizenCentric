
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repo/notificationRepo.dart';
import '../commponent/appbarcommon.dart';
import '../commponent/generalFunction.dart';
import '../resources/app_text_style.dart';


class NotificationPageHome extends StatefulWidget {
  const NotificationPageHome({super.key});

  @override
  State<NotificationPageHome> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NotificationPageHome> {

  List<Map<String, dynamic>>? notificationList;
  String? sName, sContactNo;
  GeneralFunction generalFunction = GeneralFunction();

  getnotificationResponse() async {
    notificationList = await NotificationRepo().notification(context);
    print('------26----$notificationList');
    setState(() {
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getlocalvalue();
    getnotificationResponse();
    super.initState();
  }
  getlocalvalue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sName = prefs.getString('sName') ?? "";
      sContactNo = prefs.getString('sContactNo') ?? "";
      print("------148---$sName");
      print("------1149---$sContactNo");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppCommonAppBar(
      title: "Notification" , //title: AppStrings.parkGeotagging.tr(), // title: "Park Geotagging",
      showBack: true,
      onBackPressed: () {
        print("Back pressed");
        Navigator.pop(context);
      },
    ),
      body: (notificationList == null || notificationList!.isEmpty)
        ? const Center(
      child: Text(
        "No Notification",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    )
        : Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: ListView.separated(
        itemCount: notificationList!.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.notification_important,
                  size: 30,
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        notificationList![index]['sTitle']?.toString() ?? '',
                        style: AppTextStyle
                            .font14OpenSansRegularBlackTextStyle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        notificationList![index]['sNotification']
                            ?.toString() ??
                            '',
                        style: AppTextStyle
                            .font12OpenSansRegularBlack45TextStyle,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 18,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            notificationList![index]['dRecivedAt']
                                ?.toString() ??
                                '',
                            style: AppTextStyle
                                .font12OpenSansRegularBlack45TextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),

    );

  }
}
