import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:citizencentric/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../app/di.dart';
import '../../../domain/model/model.dart';
import '../../common/state_renderer/state_render_impl.dart';
import '../../resources/color_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/values_manager.dart';
import 'home_viewmodel.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomeViewModel _viewModel = instance<HomeViewModel>();// MODEL

  @override
  void initState() {
    _bind();
    super.initState();
  }
  void didChangeDependencies() {
    // call a api in a view
   // _bind();
    print("-----Call a api in a didChangeDependencies-----");
    super.didChangeDependencies();
  }

  // bind view to ViewModel

  _bind() {
    _viewModel.start();
  }

  @override
  dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: StreamBuilder<FlowState>( // FlowState is a class Rendering state dialog
          stream: _viewModel.outputState,
          builder: (context, snapshot)
          {
            final state = snapshot.data;
            return state?.getScreenWidget(
                context,
                _getContentWidgets(),
                    () {
                  _viewModel.start();
                }) ?? _getContentWidgets();
          },
        ),
      ),
    );
  }

  // ui part
  Widget _getContentWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getBannersCarousel(),
        _getSection(AppStrings.services.tr()),
        _getServices(),
        _getSection(AppStrings.stores.tr()),
        _getStores()
      ],
    );
  }

  Widget _getSection(String title) {
    return Padding(
      padding: EdgeInsets.only(
          top: AppPadding.p12,
          left: AppPadding.p12,
          right: AppPadding.p12,
          bottom: AppPadding.p2),
      child: Text(
        title,
        style: Theme
            .of(context)
            .textTheme
            .labelMedium,
      ),
    );
  }

  Widget _getBannersCarousel() {
    return StreamBuilder<List<StaffListModel>>(
        stream: _viewModel.outputBanners,
        builder: (context, snapshot) {
          return _getBanner(snapshot.data);
        });
  }
  // bannerui code
  Widget _getBanner(List<StaffListModel>? banners) {
    if (banners != null) {
      return CarouselSlider(
          items: banners
              .map((banner) =>
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: AppSize.s1_5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.s12),
                      side: BorderSide(
                          color: ColorManager.white,
                          width: AppSize.s1_5)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.s12),
                    child: Image.network(
                      banner.sEmpImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ))
              .toList(),
          options: CarouselOptions(
              height: AppSize.s190,
              autoPlay: true,
              enableInfiniteScroll: true,
              enlargeCenterPage: true));
    } else {
      return Container();
    }
  }

// service
  Widget _getServices() {
    return StreamBuilder<List<StaffListModel>>(
        stream: _viewModel.outputServices,
        builder: (context, snapshot) {
          return _getServicesWidget(snapshot.data);
        });
  }

// services ui code
  Widget _getServicesWidget(List<StaffListModel>? services) {
    if (services != null) {
      return Padding(
        padding: EdgeInsets.only(left: AppPadding.p12, right: AppPadding.p12),
        child: Container(
          height: AppSize.s170,
          margin: EdgeInsets.symmetric(vertical: AppMargin.m12),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: services
                .map((service) =>
                Card(
                  elevation: AppSize.s4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.s12),
                      side: BorderSide(
                          color: ColorManager.white, width: AppSize.s1_5)),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.s12),
                        child: Image.network(
                          service.sEmpImage,
                          fit: BoxFit.cover,
                          width: AppSize.s130,
                          height: AppSize.s130,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: AppPadding.p8),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            service.sEmpName,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ))
                .toList(),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  // store ui
  Widget _getStores() {
    return StreamBuilder<List<StaffListModel>>(
        stream: _viewModel.outputStores,
        builder: (context, snapshot) {
          return _getStoresWidget(snapshot.data);
        });
  }

  //
  Widget _getStoresWidget(List<StaffListModel>? stores) {
    if (stores != null) {
      return Padding(
        padding: EdgeInsets.only(
            left: AppPadding.p12, right: AppPadding.p12, top: AppPadding.p12),
        child: Flex(
          direction: Axis.vertical,
          children: [
            GridView.count(
              crossAxisSpacing: AppSize.s8,
              mainAxisSpacing: AppSize.s8,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(stores.length, (index) {
                return InkWell(
                  onTap: () {
                    // navigate to store details screen
                    Navigator.of(context).pushNamed(Routes.storeDetailsRoute);
                  },
                  child: Card(
                    elevation: AppSize.s4,
                    child: Image.network(
                      stores[index].sEmpImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}