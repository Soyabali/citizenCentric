import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../app/di.dart';
import '../../domain/model/model.dart';
import '../commponent/CircleWithSpacing.dart';
import '../commponent/appbarcommon.dart';
import '../commponent/platform_text.dart';
import '../fullScreenImage/FullScreenImageDialog.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/text_type.dart';
import 'glowIcon.dart';
import 'inspectionListViewModel.dart';
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
  var selectedDropDownSectorCode;

  List<InspectionStatusModel> pendingInternalComplaintList = [];
  List<InspectionStatusModel> _filteredData = [];
  List<InspectionStatusModel> _allData = [];
  TextEditingController _searchController = TextEditingController();
  final distDropdownFocus = GlobalKey();
  bool isLoading = true;
  List<Map<String, dynamic>>? item;
  final FocusNode _searchFocusNode = FocusNode();
  late InspectionListViewModel _viewModel;

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

  Color getCardColor(int index) {
    if (cardColors.isEmpty) return Colors.white;
    return cardColors[index % cardColors.length];
  }

  // build CardItem
  Widget buildCardItem(
    BuildContext context,
    InspectionStatusModel item,
    int index,
  ) {
    // bg color
    // final Color bgColor = cardColors[index % cardColors.length];
    final Color bgColor = getCardColor(index); // SAFE

    return Padding(
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
                        child: PlatformText(
                          "${index + 1}", // "Short Worker Found", // item.sParkName ?? '',
                          type: AppTextType.subtitle,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Divider(height: 1, color: ColorManager.grey),
                      const SizedBox(width: 10),
                      // 📝 Column with 2 TextViews (flexible)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PlatformText(
                              item.parkName, // "Short Worker Found", // item.sParkName ?? '',
                              type: AppTextType.body,
                            ),
                            SizedBox(height: 4),
                            PlatformText(
                              item.reportType, //"Report Type", // item.sParkName ?? '',
                              type: AppTextType.subtitle,
                            ),
                          ],
                        ),
                      ),
                      // 🖼 Asset Image (right side)
                      GestureDetector(
                        onTap: () {
                          final double lat = item.latitude;
                          final double long = item.longitude;
                          launchGoogleMaps(lat, long);
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
              Divider(height: 1, color: Colors.grey),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                        item.divisionName, // "Satish" ,//  AppStrings.powerd_by.tr(),
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
                        item.sectorName, //"R.Singh", //  AppStrings.powerd_by.tr(),
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
                        item.parkName, //"R.Singh", //  AppStrings.powerd_by.tr(),
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
                        item.agencyName, //"M/S Green Star Nursery", //  AppStrings.powerd_by.tr(),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: CircleWithSpacing(),
                                  ),
                                  SizedBox(width: 2),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      PlatformText(
                                        "Inspection By", //  AppStrings.powerd_by.tr(),
                                        type: AppTextType.body,
                                      ),
                                      PlatformText(
                                        item.inspectedBy, //"Annand Mohan Singh",  //"AssetDirector", // item.sAssetDirector ?? "", //"Mukesh Kumar", //  AppStrings.powerd_by.tr(),
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
                                color: item.status.toLowerCase() == "pending"
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
                                  item.status,
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
                      padding: EdgeInsets.only(left: 24),
                      child: PlatformText(
                        "₹ ${item.penaltyCharges}", //  AppStrings.powerd_by.tr(}",
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
                        (item.description.isNotEmpty &&
                                item.description.isNotEmpty)
                            ? item.description
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
                        item.googleLocation, //"Noida authority parking, B-96A, D Block, Sector 6, Noida, Uttar Pradesh 201301,India Noida Uttar Pradesh",
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
                        child: ClipRRect(
                          // 🔥 IMPORTANT: clips inner content
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: Image.asset(
                                            "assets/images/ic_request_nw.png",
                                            fit: BoxFit.cover,
                                            height: 22,
                                            width: 22,
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Insp At : ',
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              "${item.inspectedAt}",
                                              maxLines: 1,
                                              overflow: TextOverflow
                                                  .ellipsis, // 👈 prevents right overflow
                                              softWrap: false,
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // PlatformText(
                                        //   "Insp At : ${item.dInspAt ?? ""}",
                                        //   type: AppTextType.body,
                                        // ),
                                      ],
                                    ),
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
                                    onTap: () {
                                      var images = "${item.photoUrl}";

                                      if (images.isNotEmpty) {
                                        showGeneralDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          barrierLabel: "Close image preview", // ✅ REQUIRED
                                          barrierColor: Colors.black,
                                          transitionDuration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          pageBuilder: (_, __, ___) {
                                            return FullScreenImageDialog(
                                              imageUrl: images,
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Image',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontWeight:
                                                  FontWeight.bold, // 👈 bold
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          //Icon(Icons.arrow_forward_ios,size: 20),
                                          const GlowIcon(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void searchPark() {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      _filteredData = _allData;
    } else {
      _filteredData = _allData.where((item) {
        return item.parkName.toLowerCase().contains(query) ||
            item.reportType.toLowerCase().contains(query) ||
            item.divisionName.toLowerCase().contains(query) ||
            item.sectorName.toLowerCase().contains(query) ||
            item.agencyName.toLowerCase().contains(query) ||
            item.agencyName.toLowerCase().contains(query) ||
            item.inspectedBy.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query) ||
            item.googleLocation.toLowerCase().contains(query);
      }).toList();
    }
    setState(() {});
  }

  @override
  void initState() {
    _viewModel = instance<InspectionListViewModel>();
    _viewModel.start();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.removeListener(searchPark);
    _searchFocusNode.dispose();
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorManager.white,

        appBar: AppCommonAppBar(
          title: "Inspection List",
          showBack: true,
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Divider(height: 1),
            // // SearchBar
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Container(
                  height: 48, // 👈 standard professional height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400, width: 0.9),
                  ),
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (_) => searchPark(),
                    textAlignVertical: TextAlignVertical.center, // 👈 KEY FIX
                    decoration: InputDecoration(
                      // 🔹 ICON
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.search,
                          size: 22,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),

                      // 🔹 TEXT
                      hintText: AppStrings.enterKeywords.tr(),
                      hintStyle: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF707d83),
                      ),

                      // 🔥 REMOVE ALL INTERNAL BORDERS
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      // 🔹 PADDING CONTROL
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: StreamBuilder<List<InspectionStatusModel>>(
                stream: _viewModel.outputInspectionList,
                builder: (context, snapshot) {
                  // 🔹 LOADING
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // 🔹 ERROR / EMPTY API
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No inspection data found"),
                    );
                  }
                  // 🔹 SUCCESS
                  final list = snapshot.data!;
                  // 🔹 Always keep original data updated
                  _allData = list;
                  // 🔹 If search box empty → show full list
                  if (_searchController.text.isEmpty) {
                    _filteredData = list;
                  }
                  final displayList = _filteredData;
                  // 🔹 NO SEARCH RESULTS
                  if (displayList.isEmpty) {
                    return const Center(child: Text("No matching results"));
                  }
                  return ListView.builder(
                    itemCount: displayList.length, // ✅ FIXED
                    itemBuilder: (context, index) {
                      final item = displayList[index]; // ✅ SAFE
                      return buildCardItem(context, item, index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
