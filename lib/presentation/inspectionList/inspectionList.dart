import 'package:citizencentric/presentation/commponent/fullscreenimage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/repo/inspectionStatusRepo.dart';
import '../../domain/model/InspectionStatusModel.dart';
import '../commponent/CircleWithSpacing.dart';
import '../commponent/CommonShimmer.dart';
import '../commponent/appbarcommon.dart';
import '../commponent/platform_text.dart';
import '../nodatascreen/nodatascreen.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/text_type.dart';
import 'glowIcon.dart';
import 'lunch_Google_Map.dart';

class InspectionList extends StatefulWidget {
  const InspectionList({super.key});

  @override
  State<InspectionList> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<InspectionList> {

  List<dynamic> subCategoryList = [];
  List<dynamic> wardList = [];
  List<dynamic> sectorList = [];
  var dropDownSubCategory;
  var dropDownSector;
  var _dropDownWard, _selectedSubCategoryId;
  var selectedDropDownSectorCode;

  List<InspectionStatusModel> pendingInternalComplaintList = [];
  List<InspectionStatusModel> _filteredData = [];
  TextEditingController _searchController = TextEditingController();
  final distDropdownFocus = GlobalKey();
  bool isLoading = true;
  int _listRequestId = 0;
  //var item;
  List<Map<String, dynamic>>? item;
  final FocusNode _searchFocusNode = FocusNode();

  // list of the color
  final List<Color> cardColors = [
    Color(0xFFCA7598),
    Color(0xFF9BC376),
    Color(0xFF64BAB0),
    Color(0xFFF6D195),
    Color(0xFF7DCCD7),
    Color(0xFFDB957F),
    Color(0xFF7CACDE),
    Color(0xFFC88BE2),
    Color(0xFFEBB072),
    Color(0xFF8BC2D0),
  ];
  Widget _iosActionItem({
    double? width,
    required String title,
    required VoidCallback onTap,
    int maxLines = 1,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      splashColor: Colors.grey.withOpacity(0.15), // 👈 iOS-like
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: width,
        height: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _divider() {
    return Container(
      height: 26,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
  // build CardItem
  Widget buildCardItem(BuildContext context, InspectionStatusModel item, int index) {
    // bg color

    final Color bgColor = cardColors[index % cardColors.length];

    return  Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.fromLTRB(4, 4, 4, 4), // 👈 FIX 1
        clipBehavior: Clip.none, // 👈 FIX 2
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Colors.grey, // 👈 YOUR BORDER COLOR
            width: 1,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      // 🔴 Circle Container (60x60)
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                        ),
                        // child: Text(
                        //   "${index+1}",
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        child:  PlatformText(
                           "${index+1}", // "Short Worker Found", // item.sParkName ?? '',
                          type: AppTextType.subtitle,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Divider(height: 1,
                      color: ColorManager.grey,
                      ),
                      const SizedBox(width: 10),
                      // 📝 Column with 2 TextViews (flexible)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            PlatformText(
                              item.sParkName ?? '', // "Short Worker Found", // item.sParkName ?? '',
                              type: AppTextType.body,
                            ),
                            SizedBox(height: 4),
                            PlatformText(
                              item.sReportType ?? '', //"Report Type", // item.sParkName ?? '',
                              type: AppTextType.subtitle,
                            ),
                          ],
                        ),
                      ),
                      // 🖼 Asset Image (right side)
                      GestureDetector(
                        onTap: (){
                          //   item.sDevisionName ?? ""
                          final double lat = item.fLatitude;
                          final double long = item.fLongitude;
                          print("---lat----$lat");
                          print("---long----$long");
                          // navigate to googleMap
                          if (lat != null && long != null) {
                            launchGoogleMaps(lat, long);
                          } else {
                            //displayToast("Please check the location.");

                          }
                        },

                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            'assets/images/googlemap.jpeg', // change path
                            width: 30,
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 5),
                        CircleWithSpacing(),
                        PlatformText(
                          "Division", //  AppStrings.powerd_by.tr(),
                          type: AppTextType.body,
                        ),
                        //Text('Supervisor', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: PlatformText(
                        item.sDevisionName ?? "", // "Satish" ,//  AppStrings.powerd_by.tr(),
                        type: AppTextType.subtitle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 5),
                        CircleWithSpacing(),
                        PlatformText(
                          "Sector", //  AppStrings.powerd_by.tr(),
                          type: AppTextType.body,
                        ),
                        //Text('Deputy Director', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: PlatformText(
                        item.sSectorName ?? "",//"R.Singh", //  AppStrings.powerd_by.tr(),
                        type: AppTextType.subtitle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 5),
                        CircleWithSpacing(),
                        PlatformText(
                          "Park Name", //  AppStrings.powerd_by.tr(),
                          type: AppTextType.body,
                        ),
                        //Text('Deputy Director', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: PlatformText(
                        item.sParkName ?? "",  //"R.Singh", //  AppStrings.powerd_by.tr(),
                        type: AppTextType.subtitle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 5),
                        CircleWithSpacing(),
                        PlatformText(
                          "Agency Name", //  AppStrings.powerd_by.tr(),
                          type: AppTextType.body,
                          color: ColorManager.primary,
                        ),
                        //Text('Agency Name', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: PlatformText(
                        item.sAgencyName?? "" ,//"M/S Green Star Nursery", //  AppStrings.powerd_by.tr(),
                        type: AppTextType.subtitle,
                        color: ColorManager.primary,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 7, // 90%
                          child: Container(
                            // color: Colors.blue.shade400,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                    ),
                                    child: CircleWithSpacing(),
                                  ),
                                  SizedBox(width: 2),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      PlatformText(
                                        "Inspection By", //  AppStrings.powerd_by.tr(),
                                        type: AppTextType.body,
                                      ),
                                      PlatformText(
                                        item.sInspBy?? "" , //"Annand Mohan Singh",  //"AssetDirector", // item.sAssetDirector ?? "", //"Mukesh Kumar", //  AppStrings.powerd_by.tr(),
                                        type: AppTextType.subtitle,
                                      ),
                                    ],
                                  ),

                                  //Text('Assistant Director', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3, // 10%
                          child: GestureDetector(
                            onTap: () {
                              print('---forward----click---');
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: item.sStatus?.toLowerCase() == "pending"
                                    ? Colors.red
                                    : bgColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // decoration: BoxDecoration(
                              //   color: (item.sStatus?.toLowerCase() == "Pending")
                              //       ? Colors.red
                              //       : bgColor,
                              //   borderRadius: BorderRadius.circular(20),
                              // ),
                              child: Center(
                                // child: PlatformText(
                                //     item.sStatus, //  AppStrings.powerd_by.tr(),
                                //     type: AppTextType.subtitle,
                                //     color: ColorManager.white,
                                //
                                //   ),
                                  child: Text(
                                    item.sStatus ?? "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),

                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 5),
                        CircleWithSpacing(),
                        PlatformText(
                          "Panelty Charge", //  AppStrings.powerd_by.tr(),
                          type: AppTextType.body,
                        ),
                        //Text('Deputy Director', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                      ],
                    ),
                    //  fPaneltyCharges
                    Padding(
                      padding:EdgeInsets.only(left: 24),
                      child: PlatformText(
                        "₹ ${item.fPaneltyCharges}",
                        type: AppTextType.subtitle,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 5),
                        CircleWithSpacing(),
                        PlatformText(
                          "Description", //  AppStrings.powerd_by.tr(),
                          type: AppTextType.body,
                        ),
                        //Text('Deputy Director', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: PlatformText(
                        (item.sDescription != null && item.sDescription!.isNotEmpty)
                            ? item.sDescription!
                            : "No Description",
                        type: AppTextType.subtitle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 5),
                        CircleWithSpacing(),
                        PlatformText(
                          "Google Location", //  AppStrings.powerd_by.tr(),
                          type: AppTextType.body,
                        ),
                        //Text('Deputy Director', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: PlatformText(
                        item.sGoogleLocation?? "" , //"Noida authority parking, B-96A, D Block, Sector 6, Noida, Uttar Pradesh 201301,India Noida Uttar Pradesh",
                        type: AppTextType.subtitle,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: ClipRRect( // 🔥 IMPORTANT: clips inner content
                          borderRadius: BorderRadius.circular(14),
                          child: SizedBox(
                            height: 52,
                            width: double.infinity,
                            child: Row(
                              children: [
                                /// 70% LEFT
                                Expanded(
                                  flex: 6,
                                  child: Container(

                                    alignment: Alignment.centerLeft,
                                   // padding: const EdgeInsets.symmetric(horizontal: 12),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8),
                                                  child: Image.asset(
                                                    "assets/images/ic_request_nw.png",
                                                    fit: BoxFit.cover,
                                                    height: 22,
                                                    width: 22,
                                                  ),
                                                ),
                                        SizedBox(width: 2),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text('Insp At : ',style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12
                                                    ),),
                                                    SizedBox(width: 2),
                                                    Text(
                                                      "${item.dInspAt}",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis, // 👈 prevents right overflow
                                                      softWrap: false,
                                                      style: const TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                // PlatformText(
                                                //   "Insp At : ${item.dInspAt ?? ""}",
                                                //   type: AppTextType.body,
                                                // ),

                                      ],
                                    )
                                  ),
                                ),

                                /// DIVIDER
                                Container(
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),

                                /// 30% RIGHT
                                Expanded(
                                  flex: 4,
                                  child: InkWell(
                                    onTap: (){
                                              print('---forward----click---');
                                              var images = "${item.sPhoto}";
                                              print("----445---$images");

                                              if(images!=null)
                                              {
                                                if (images != null && images.isNotEmpty) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => FullScreenPage(
                                                        sBeforePhoto: images,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }

                                    },
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Image',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold, // 👈 bold
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          //Icon(Icons.arrow_forward_ios,size: 20),
                                          const GlowIcon(),


                                        ],
                                      )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Card(
                  //   margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  //   elevation: 0, // 👈 very soft
                  //   color: Colors.white.withOpacity(0.85), // 👈 almost white
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(12),
                  //     side: BorderSide(
                  //       color: Colors.grey.shade200, // 👈 subtle border
                  //     ),
                  //   ),
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: <Widget>[
                  //        // const SizedBox(width: 5),
                  //
                  //         /// Icon
                  //         Image.asset(
                  //           "assets/images/ic_request_nw.png",
                  //           fit: BoxFit.cover,
                  //           height: 22,
                  //           width: 22,
                  //         ),
                  //
                  //         const SizedBox(width: 8),
                  //
                  //         /// Inspection Time
                  //         PlatformText(
                  //           "Insp At : ${item.dInspAt ?? ""}",
                  //           type: AppTextType.body,
                  //         ),
                  //
                  //         const Spacer(),
                  //
                  //         /// View Image Action
                  //         GestureDetector(
                  //           onTap: () {
                  //             var images = item.sPhoto;
                  //           print("-----------------$images");
                  //
                  //             if (images != null && images.isNotEmpty) {
                  //               Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (_) =>
                  //                       FullScreenPage(sBeforePhoto: images),
                  //                 ),
                  //               );
                  //             }
                  //           },
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(right: 6),
                  //             child: Row(
                  //               children: const [
                  //                 PlatformText(
                  //                   "View Image",
                  //                   type: AppTextType.subtitle,
                  //                 ),
                  //                 SizedBox(width: 4),
                  //                 Icon(
                  //                   Icons.arrow_forward_ios,
                  //                   size: 16,
                  //                   color: Colors.black54,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: <Widget>[
                    //     SizedBox(width: 5),
                    //     // CircleWithSpacing(),
                    //    // Icon(Icons.file_copy_sharp,size: 30),
                    //    Image.asset("assets/images/ic_request_nw.png",fit: BoxFit.cover,height: 22,width: 22),
                    //     SizedBox(width: 5),
                    //     PlatformText(
                    //       "Insp At : ${item.dInspAt?? "" }", //  AppStrings.powerd_by.tr(),
                    //       type: AppTextType.body,
                    //     ),
                    //     Spacer(),
                    //     GestureDetector(
                    //       onTap: (){
                    //         print('---forward----click---');
                    //         var images = "${item.sPhoto}";
                    //         print("----445---$images");
                    //
                    //         if(images!=null)
                    //         {
                    //           if (images != null && images.isNotEmpty) {
                    //             Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) => FullScreenPage(
                    //                   sBeforePhoto: images,
                    //                 ),
                    //               ),
                    //             );
                    //           }
                    //         }
                    //         },
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(right: 10),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.end,
                    //           crossAxisAlignment: CrossAxisAlignment.end,
                    //           children: [
                    //             PlatformText(
                    //               "View Image", //  AppStrings.powerd_by.tr(),
                    //               type: AppTextType.subtitle,
                    //             ),
                    //             Icon(Icons.arrow_forward_ios,size: 20),
                    //
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     //Text('Deputy Director', style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                    //   ],
                    // ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pendingInternalComplaintResponse() async {
    final int requestId = ++_listRequestId;

    setState(() => isLoading = true);

    final result = await InspectionStartRepo().inspectionStartRepo(
      context,
    );

    // 🔒 IGNORE OLD RESPONSE
    if (requestId != _listRequestId) return;

    if (result != null) {
      pendingInternalComplaintList = result;
      _filteredData = List.from(result);
      print("---761---ListData----: $pendingInternalComplaintList");
    } else {
      pendingInternalComplaintList = [];
      _filteredData = [];
    }

    setState(() => isLoading = false);
  }

  // search logic
  void searchPark() {
    final query = _searchController.text.toLowerCase();

    _filteredData = pendingInternalComplaintList.where((park) {
      return park.sParkName.toLowerCase().contains(query) ||
          park.sAgencyName.toLowerCase().contains(query) ||
          park.sSectorName.toLowerCase().contains(query) ||
          park.sDevisionName.toLowerCase().contains(query) ||
          park.sReportType.toLowerCase().contains(query);
    }).toList();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    pendingInternalComplaintResponse();
    _searchController.addListener(searchPark);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.unfocus(); // 👈 closes keyboard
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.removeListener(searchPark);
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: ColorManager.white,
          appBar: AppCommonAppBar(
           title: "Inspection List" , //title: AppStrings.parkGeotagging.tr(), // title: "Park Geotagging",
            showBack: true,
            onBackPressed: () {
              print("Back pressed");
              Navigator.pop(context);
            },
          ),
          body: Column(
            children: [
              // Divider(height: 1),
              // // SearchBar
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.grey, // Outline border color
                        width: 0.2, // Outline border width
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _searchController,
                            autofocus: false,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              // hintText: 'Enter Keywords',
                              hintText: AppStrings.enterKeywords.tr(),
                              hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Color(0xFF707d83),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // here list item start
              SizedBox(height: 10),
              /// todo heere you bind the list
              // at dynamic list you should remove this card content and uncomment below code to show
              // dynamic data
              /// todo here is a list i am close some time such as a i play static code.

              Expanded(
                child: isLoading
                    ? CommonShimmerList()
                    : (pendingInternalComplaintList == null ||
                    pendingInternalComplaintList!.isEmpty)
                    ? NoDataScreenPage()
                    : Padding(
                  padding: const EdgeInsets.only(left: 8.0,top: 8.0,bottom: 8.0,right: 4.0),
                  child: ListView.builder(
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      // final item = _filteredData[index];
                      final InspectionStatusModel item = _filteredData[index];

                      return buildCardItem(context, item,index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
