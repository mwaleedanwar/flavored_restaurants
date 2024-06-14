import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/config_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/branch_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/localization_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/location_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_dialog.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/branch/widget/bracnh_cart_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'widget/branch_item_view.dart';

class BranchListScreen extends StatefulWidget {
  const BranchListScreen({Key key}) : super(key: key);

  @override
  State<BranchListScreen> createState() => _BranchListScreenState();
}

class _BranchListScreenState extends State<BranchListScreen> {
  List<BranchValue> _branchesValue = [];
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController _mapController;
  LatLng _currentLocationLatLng;
  AutoScrollController scrollController;

  @override
  void initState() {
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    branchProvider.updateTabIndex(0, isUpdate: false);

    ///if need to previous selection
    if (branchProvider.getBranchId() == -1) {
      branchProvider.updateBranchId(null, isUpdate: false);
    } else {
      branchProvider.updateBranchId(branchProvider.getBranchId(), isUpdate: false);
    }
    // _branches = Provider.of<SplashProvider>(context, listen: false).configModel.branches;

    Provider.of<LocationProvider>(context, listen: false).getCurrentLatLong().then((latLong) {
      if (latLong != null) {
        _currentLocationLatLng = latLong;
      }
      _branchesValue = branchProvider.branchSort(_currentLocationLatLng);
    });

    scrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BranchProvider>(builder: (context, branchProvider, _) {
      return WillPopScope(
        onWillPop: () async {
          if (branchProvider.branchTabIndex != 0) {
            branchProvider.updateTabIndex(0);
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: ResponsiveHelper.isDesktop(context)
              ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100))
              : CustomAppBar(
                  context: context,
                  title: 'Choose Store',
                  isBackButtonExist: true,
                ),
          body: Center(
              child: SizedBox(
            width: Dimensions.WEB_SCREEN_WIDTH,
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                child: branchProvider.branchTabIndex == 1
                    ? Stack(
                        children: [
                          GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                double.parse(_branchesValue[0].branches.latitude),
                                double.parse(_branchesValue[0].branches.longitude),
                              ),
                              zoom: 5,
                            ),
                            minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                            zoomControlsEnabled: true,
                            markers: _markers,
                            onMapCreated: (GoogleMapController controller) async {
                              await Geolocator.requestPermission();
                              _mapController = controller;
                              // _loading = false;
                              _setMarkers(1);
                            },
                          ),
                          Positioned.fill(
                              child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SingleChildScrollView(
                              controller: scrollController,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _branchesValue
                                    .map((branchValue) => AutoScrollTag(
                                          controller: scrollController,
                                          key: ValueKey(_branchesValue.indexOf(branchValue)),
                                          index: _branchesValue.indexOf(branchValue),
                                          child: BranchCartView(
                                            branchModel: branchValue,
                                            branchModelList: _branchesValue,
                                            onTap: () => _setMarkers(_branchesValue.indexOf(branchValue),
                                                fromBranchSelect: true),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          )),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.PADDING_SIZE_SMALL, horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Nearest Store (${_branchesValue.length})', style: rubikBold),
                              GestureDetector(
                                onTap: () => branchProvider.updateTabIndex(1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: Theme.of(context).primaryColor),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius:
                                                Provider.of<LocalizationProvider>(context, listen: false).isLtr
                                                    ? BorderRadius.only(
                                                        bottomLeft: Radius.circular(30),
                                                        topLeft: Radius.circular(30),
                                                      )
                                                    : BorderRadius.only(
                                                        bottomRight: Radius.circular(30),
                                                        topRight: Radius.circular(30),
                                                      )),
                                        child: Icon(
                                          Icons.my_location_rounded,
                                          color: Colors.white,
                                          size: Dimensions.PADDING_SIZE_DEFAULT,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        child: Text(
                                          'Select From Map',
                                          style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          _branchesValue != null && _branchesValue.isNotEmpty
                              ? Flexible(
                                  child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 50,
                                    mainAxisSpacing:
                                        ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0.01,
                                    childAspectRatio: ResponsiveHelper.isDesktop(context) ? 3.6 : 2.5,
                                    crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                                  ),
                                  itemCount: _branchesValue.length,
                                  itemBuilder: (context, index) => BranchItemView(
                                    branchesValue: _branchesValue[index],
                                  ),
                                ))
                              : CircularProgressIndicator(),
                        ]),
                      ),
              ),
              Container(
                width: Dimensions.WEB_SCREEN_WIDTH,
                padding: EdgeInsets.all(Dimensions.FONT_SIZE_DEFAULT),
                child: Consumer<BranchProvider>(builder: (context, branchProvider, _) {
                  final _cartProvider = Provider.of<CartProvider>(context, listen: false);
                  return CustomButton(
                      btnTxt: 'Confirm Branch',
                      borderRadius: 30,
                      onTap: () {
                        if (branchProvider.selectedBranchId != null) {
                          if (branchProvider.selectedBranchId != branchProvider.getBranchId() &&
                              _cartProvider.cartList.length > 0) {
                            showAnimatedDialog(
                              context,
                              CustomDialog(
                                buttonTextTrue: 'Yes',
                                buttonTextFalse: 'Now',
                                description: '',
                                icon: Icons.question_mark,
                                title:
                                    'You have some foods in your cart. If you change your Branch, your cart data will be reset.',
                                onTapTrue: () {
                                  _cartProvider.clearCartList();
                                  _setBranch();
                                },
                                onTapFalse: () => Navigator.of(context).pop(),
                              ),
                              dismissible: false,
                              isFlip: true,
                            );
                          } else {
                            if (branchProvider.branchTabIndex != 0) {
                              branchProvider.updateTabIndex(0, isUpdate: false);
                            }

                            _setBranch();
                          }
                        } else {
                          showCustomSnackBar('Select branch first', context);
                        }
                      });
                }),
              )
            ]),
          )),
        ),
      );
    });
  }

  void _setBranch() {
    final _branchProvider = Provider.of<BranchProvider>(context, listen: false);

    _branchProvider.setBranch(_branchProvider.selectedBranchId);
    Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
    showCustomSnackBar('Branch successfully selected', context, isError: false);

    // if(_branchProvider.getBranchId() != _branchProvider.selectedBranchId) {
    //   _branchProvider.setBranch(_branchProvider.selectedBranchId);
    //   Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
    //   showCustomSnackBar('Branch successfully selected', context, isError: false);
    // }else{
    //   showCustomSnackBar('This is your current branch, please select another branch to change', context);
    // }
  }

  void _setMarkers(int selectedIndex, {bool fromBranchSelect = false}) async {
    BitmapDescriptor _bitmapDescriptor;
    BitmapDescriptor _bitmapDescriptorUnSelect;
    BitmapDescriptor _currentLocationDescriptor;

    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(30, 50)), Images.restaurant_marker)
        .then((_marker) {
      _bitmapDescriptor = _marker;
    });

    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(25, 40)), Images.restaurant_marker_unselect)
        .then((_marker) {
      _bitmapDescriptorUnSelect = _marker;
    });

    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(30, 50)), Images.current_location_marker)
        .then((_marker) {
      _currentLocationDescriptor = _marker;
    });

    // Marker
    _markers = HashSet<Marker>();
    for (int index = 0; index < _branchesValue.length; index++) {
      _markers.add(Marker(
        onTap: () async {
          await scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
          scrollController.highlight(index);
          if (_branchesValue[index].branches.status) {
            Provider.of<BranchProvider>(context, listen: false).updateBranchId(_branchesValue[index].branches.id);
          }
        },
        markerId: MarkerId('branch_$index'),
        position: LatLng(double.parse(_branchesValue[index].branches.latitude),
            double.parse(_branchesValue[index].branches.longitude)),
        infoWindow:
            InfoWindow(title: _branchesValue[index].branches.name, snippet: _branchesValue[index].branches.address),
        visible: _branchesValue[index].branches.status,
        icon: selectedIndex == index ? _bitmapDescriptor : _bitmapDescriptorUnSelect,
      ));
    }
    if (_currentLocationLatLng != null) {
      _markers.add(Marker(
        markerId: MarkerId('current_location'),
        position: _currentLocationLatLng,
        infoWindow: InfoWindow(title: getTranslated('current_location', context), snippet: ''),
        icon: _currentLocationDescriptor,
      ));
    }

    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _currentLocationLatLng != null && !fromBranchSelect
          ? _currentLocationLatLng
          : LatLng(
              double.parse(_branchesValue[selectedIndex].branches.latitude),
              double.parse(_branchesValue[selectedIndex].branches.longitude),
            ),
      zoom: ResponsiveHelper.isMobile(context) ? 12 : 16,
    )));

    setState(() {});
  }
}
