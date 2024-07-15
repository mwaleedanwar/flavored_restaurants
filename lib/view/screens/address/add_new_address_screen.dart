// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/address_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/config_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/location_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/profile_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_text_field.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/address/select_location_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/address/widget/location_search_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/coupon_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/address/widget/permission_dialog.dart';
import 'package:provider/provider.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final bool isFromCart;
  final double amount;
  final AddressModel? address;
  const AddNewAddressScreen({
    super.key,
    this.isEnableUpdate = false,
    this.address,
    this.fromCheckout = false,
    this.isFromCart = false,
    this.amount = 0.0,
  });

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();

  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _stateNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();

  final List<Branches> _branches = [];
  GoogleMapController? _controller;
  late CameraPosition _cameraPosition;
  bool _updateAddress = true;

  _initLoading() async {
    final userModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
    _branches.addAll(Provider.of<SplashProvider>(context, listen: false).configModel?.branches ?? []);
    Provider.of<LocationProvider>(context, listen: false).initializeAllAddressType();
    Provider.of<LocationProvider>(context, listen: false).updateAddressStatusMessage(message: '');
    Provider.of<LocationProvider>(context, listen: false).updateErrorMessage(message: '');
    if (widget.isEnableUpdate && widget.address != null) {
      _updateAddress = false;
      Provider.of<LocationProvider>(context, listen: false).updatePosition(
        CameraPosition(
            target: LatLng(double.parse(widget.address!.latitude!), double.parse(widget.address!.longitude!))),
        true,
        context,
        false,
      );
      _contactPersonNameController.text = widget.address!.contactPersonName ?? '';
      _contactPersonNumberController.text = widget.address!.contactPersonNumber ?? '';
      _buildingController.text = widget.address?.buildingNumber ?? '';
      _floorController.text = widget.address?.floorNumber ?? '';
      if (widget.address?.addressType == 'Home') {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(0, false);
      } else if (widget.address!.addressType == 'Workplace') {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(1, false);
      } else {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(2, false);
      }
    } else {
      _contactPersonNameController.text = '${userModel?.fName ?? ''}'
          ' ${userModel?.lName ?? ''}';
      _contactPersonNumberController.text = userModel?.phone ?? '';
      _buildingController.text = widget.address?.buildingNumber ?? '';
      _floorController.text = widget.address?.floorNumber ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    _initLoading();
    if (widget.address != null && !widget.fromCheckout) {
      _locationTextController.text = widget.address!.address ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : CustomAppBar(
              context: context,
              title: widget.isEnableUpdate
                  ? getTranslated('update_address', context)
                  : getTranslated('add_new_address', context)),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight:
                                  !ResponsiveHelper.isDesktop(context) && MediaQuery.of(context).size.height < 600
                                      ? MediaQuery.of(context).size.height
                                      : MediaQuery.of(context).size.height - 400),
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                            child: Center(
                              child: SizedBox(
                                width: 1170,
                                child: Column(
                                  children: [
                                    if (!ResponsiveHelper.isDesktop(context)) mapWidget(context),
                                    // for label us
                                    if (!ResponsiveHelper.isDesktop(context)) detailsWidget(context),
                                    if (ResponsiveHelper.isDesktop(context))
                                      IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 6,
                                              child: mapWidget(context),
                                            ),
                                            const SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                                            Expanded(
                                              flex: 4,
                                              child: detailsWidget(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (ResponsiveHelper.isDesktop(context)) const FooterView(),
                      ],
                    ),
                  ),
                ),
              ),
              if (!ResponsiveHelper.isDesktop(context))
                Column(
                  children: [
                    locationProvider.addressStatusMessage != null
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (locationProvider.addressStatusMessage ?? '').isNotEmpty
                                  ? const CircleAvatar(backgroundColor: Colors.green, radius: 5)
                                  : const SizedBox.shrink(),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  locationProvider.addressStatusMessage ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.green, height: 1),
                                ),
                              )
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              locationProvider.errorMessage?.isNotEmpty ?? false
                                  ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                  : const SizedBox.shrink(),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  locationProvider.errorMessage ?? "",
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: Theme.of(context).primaryColor,
                                      height: 1),
                                ),
                              )
                            ],
                          ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    if (!ResponsiveHelper.isDesktop(context)) saveButtonWidget(context),
                  ],
                )
            ],
          );
        },
      ),
    );
  }

  Widget saveButtonWidget(BuildContext context) {
    return Consumer<LocationProvider>(builder: (context, locationProvider, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        child: SizedBox(
          height: 50.0,
          width: 1170,
          child: !locationProvider.isLoading
              ? CustomButton(
                  btnTxt: widget.isEnableUpdate
                      ? getTranslated('update_address', context)
                      : getTranslated('save_location', context),
                  onTap: locationProvider.loading
                      ? null
                      : () {
                          List<Branches>? branches =
                              Provider.of<SplashProvider>(context, listen: false).configModel!.branches;
                          bool isAvailable =
                              branches?.length == 1 && (branches?[0].latitude == null || branches![0].latitude.isEmpty);
                          if (!isAvailable) {
                            for (Branches branch in branches!) {
                              double distance = Geolocator.distanceBetween(
                                    double.parse(branch.latitude),
                                    double.parse(branch.longitude),
                                    locationProvider.position!.latitude,
                                    locationProvider.position!.longitude,
                                  ) /
                                  1000;
                              debugPrint('===distance:$distance ${branch.coverage}');
                              if (distance < branch.coverage) {
                                isAvailable = true;
                                break;
                              }
                            }
                          }
                          if (!isAvailable) {
                            showCustomSnackBar(getTranslated('service_is_not_available', context), context);
                          } else {
                            AddressModel addressModel = AddressModel(
                              addressType: locationProvider.getAllAddressType[locationProvider.selectAddressIndex],
                              contactPersonName: _contactPersonNameController.text,
                              contactPersonNumber: _contactPersonNumberController.text,
                              address: _locationTextController.text,
                              latitude: locationProvider.position!.latitude.toString(),
                              longitude: locationProvider.position!.longitude.toString(),
                              floorNumber: _floorController.text,
                              buildingNumber: _buildingController.text,
                            );

                            if (widget.isEnableUpdate) {
                              addressModel.id = widget.address?.id;
                              addressModel.userId = widget.address?.userId;
                              addressModel.method = 'put';
                              locationProvider
                                  .updateAddress(context, addressModel: addressModel, addressId: addressModel.id!)
                                  .then((value) {
                                debugPrint('===success');
                              });
                            } else {
                              locationProvider.addAddress(context, addressModel).then((value) {
                                if (value.isSuccess) {
                                  if (widget.fromCheckout) {
                                    Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
                                    Provider.of<OrderProvider>(context, listen: false).setAddressIndex(-1);
                                  } else {
                                    showCustomSnackBar(value.message, context, isError: false);
                                  }
                                  widget.isFromCart == true
                                      ? Navigator.pushReplacementNamed(
                                          context,
                                          Routes.getCheckoutRoute(
                                            widget.amount,
                                            'cart',
                                            Provider.of<OrderProvider>(context, listen: false).orderType,
                                            Provider.of<CouponProvider>(context, listen: false).code,
                                          ))
                                      : Provider.of<LocationProvider>(context, listen: false).resetPickedAddress();
                                  Navigator.pop(context);
                                } else {
                                  showCustomSnackBar(value.message, context);
                                }
                              });
                            }
                          }
                        },
                )
              : Center(
                  child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                )),
        ),
      );
    });
  }

  Container mapWidget(BuildContext context) {
    return Container(
      decoration: ResponsiveHelper.isDesktop(context)
          ? BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10), boxShadow: [
              BoxShadow(
                color: ColorResources.CARD_SHADOW_COLOR.withOpacity(0.2),
                blurRadius: 10,
              )
            ])
          : const BoxDecoration(),
      //margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_LARGE),
      padding: ResponsiveHelper.isDesktop(context)
          ? const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_LARGE)
          : EdgeInsets.zero,
      child: Consumer<LocationProvider>(builder: (context, locationProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ResponsiveHelper.isMobile(context) ? 130 : 250,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: widget.isEnableUpdate
                            ? LatLng(
                                double.tryParse((widget.address?.latitude).toString()) ??
                                    double.parse(_branches[0].latitude),
                                double.tryParse((widget.address?.longitude).toString()) ??
                                    double.parse(_branches[0].longitude))
                            : LatLng(
                                locationProvider.position?.latitude == 0.0
                                    ? double.parse(_branches[0].latitude)
                                    : locationProvider.position!.latitude,
                                locationProvider.position?.longitude == 0.0
                                    ? double.parse(_branches[0].longitude)
                                    : locationProvider.position!.longitude),
                        zoom: 8,
                      ),
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      indoorViewEnabled: true,
                      mapToolbarEnabled: false,
                      minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                      onCameraIdle: () {
                        if (widget.address != null && !widget.fromCheckout) {
                          locationProvider.updatePosition(_cameraPosition, true, context, true);
                          _updateAddress = true;
                        } else {
                          if (_updateAddress) {
                            locationProvider.updatePosition(_cameraPosition, true, context, true);
                          } else {
                            _updateAddress = true;
                          }
                        }
                      },
                      onCameraMove: ((position) => _cameraPosition = position),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                        if (!widget.isEnableUpdate && _controller != null) {
                          _checkPermission(() {
                            locationProvider.getCurrentLocation(context, true, mapController: _controller);
                          }, context);
                        }
                      },
                    ),
                    locationProvider.loading
                        ? Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                        : const SizedBox(),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset(
                          Images.marker,
                          width: 25,
                          height: 35,
                        )),
                    Positioned(
                      bottom: 10,
                      right: 0,
                      child: InkWell(
                        onTap: () => _checkPermission(() {
                          locationProvider.getCurrentLocation(context, true, mapController: _controller);
                        }, context),
                        child: Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                            color: ColorResources.COLOR_WHITE,
                          ),
                          child: Icon(
                            Icons.my_location,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 0,
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(context, Routes.getSelectLocationRoute(),
                            arguments: SelectLocationScreen(googleMapController: _controller)),
                        child: Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                            color: ColorResources.COLOR_WHITE,
                          ),
                          child: Icon(
                            Icons.fullscreen,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, Routes.getSelectLocationRoute(),
                    arguments: const SelectLocationScreen()),
                child: Center(
                    child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorResources.getGreyBunkerColor(context), width: 1.5),
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  child: Text(
                    'Adjust pin',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: ColorResources.getGreyBunkerColor(context),
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                        fontWeight: FontWeight.w500),
                  ),
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                getTranslated('label_us', context),
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(color: ColorResources.getGreyBunkerColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                // physics: BouncingScrollPhysics(),
                itemCount: locationProvider.getAllAddressType.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    locationProvider.updateAddressIndex(index, true);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_DEFAULT, horizontal: Dimensions.PADDING_SIZE_LARGE),
                    margin: const EdgeInsets.only(right: 17),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimensions.PADDING_SIZE_SMALL,
                        ),
                        border: Border.all(
                            color: locationProvider.selectAddressIndex == index
                                ? Theme.of(context).primaryColor
                                : ColorResources.BORDER_COLOR),
                        color: locationProvider.selectAddressIndex == index
                            ? Theme.of(context).primaryColor
                            : ColorResources.SEARCH_BG),
                    child: Text(
                      getTranslated(locationProvider.getAllAddressType[index].toLowerCase(), context),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: locationProvider.selectAddressIndex == index
                              ? ColorResources.COLOR_WHITE
                              : ColorResources.COLOR_BLACK),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _openSearchDialog(BuildContext context) async {
    showDialog(context: context, builder: (context) => const LocationSearchDialog());
  }

  Widget detailsWidget(BuildContext context) {
    return Consumer<LocationProvider>(builder: (context, locationProvider, _) {
      _locationTextController.text = locationProvider.address ?? '';
      return Container(
        decoration: ResponsiveHelper.isDesktop(context)
            ? BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10), boxShadow: [
                BoxShadow(
                  color: ColorResources.CARD_SHADOW_COLOR.withOpacity(0.2),
                  blurRadius: 10,
                )
              ])
            : const BoxDecoration(),
        padding: ResponsiveHelper.isDesktop(context)
            ? const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_LARGE,
                vertical: Dimensions.PADDING_SIZE_SMALL,
              )
            : EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ? 0 : 24.0),
              child: Text(
                getTranslated('delivery_address', context),
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(color: ColorResources.getGreyBunkerColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
            ),

            // for Address Field
            Text(
              getTranslated('address_line_01', context),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: ColorResources.getHintColor(context)),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            locationProvider.pickAddress != null && _controller != null
                ? InkWell(
                    onTap: () => _openSearchDialog(context),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 18.0),
                      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 23.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                      ),
                      child: Builder(builder: (context) {
                        _locationTextController.text = locationProvider.pickAddress ?? '';

                        return Row(children: [
                          Expanded(
                              child: Text(
                                  locationProvider.pickAddress == null || locationProvider.pickAddress == ''
                                      ? locationProvider.address == ''
                                          ? 'Enter address Manually'
                                          : locationProvider.address!
                                      : locationProvider.pickAddress!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)),
                          const Icon(Icons.search, size: 20),
                        ]);
                      }),
                    ),
                  )
                : const SizedBox.shrink(),

            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            Text(
              'Apt / Suite / Floor',
              style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            CustomTextField(
              hintText: getTranslated('ex_2', context),
              isShowBorder: true,
              inputType: TextInputType.streetAddress,
              inputAction: TextInputAction.next,
              focusNode: _houseNode,
              nextFocus: _floorNode,
              controller: _floorController,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            Text(
              'Business / Building Name',
              style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

            CustomTextField(
              hintText: 'Ex: hotel, school etc.',
              isShowBorder: true,
              inputType: TextInputType.streetAddress,
              inputAction: TextInputAction.next,
              focusNode: _stateNode,
              nextFocus: _houseNode,
              controller: _buildingController,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            // for Contact Person Name
            Text(
              getTranslated('contact_person_name', context),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: ColorResources.getHintColor(context)),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            CustomTextField(
              hintText: getTranslated('enter_contact_person_name', context),
              isShowBorder: true,
              inputType: TextInputType.name,
              controller: _contactPersonNameController,
              focusNode: _nameNode,
              nextFocus: _numberNode,
              inputAction: TextInputAction.next,
              capitalization: TextCapitalization.words,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            // for Contact Person Number
            Text(
              getTranslated('contact_person_number', context),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: ColorResources.getHintColor(context)),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            CustomTextField(
              hintText: getTranslated('enter_contact_person_number', context),
              isShowBorder: true,
              inputType: TextInputType.phone,
              inputAction: TextInputAction.done,
              focusNode: _numberNode,
              controller: _contactPersonNumberController,
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            const SizedBox(
              height: Dimensions.PADDING_SIZE_DEFAULT,
            ),
            if (ResponsiveHelper.isDesktop(context)) saveButtonWidget(context),
          ],
        ),
      );
    });
  }

  void _checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      _locationTextController.text = '';
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      _locationTextController.text = '';
      showDialog(context: context, barrierDismissible: false, builder: (context) => const PermissionDialog());
    } else {
      callback();
    }
  }
}
