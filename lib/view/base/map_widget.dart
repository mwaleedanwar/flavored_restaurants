import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final DeliveryAddress address;
  const MapWidget({super.key, required this.address});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late LatLng _latLng;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    _latLng = LatLng(double.parse(widget.address.latitude), double.parse(widget.address.longitude));
    _setMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: WebAppBar(),
            )
          : CustomAppBar(context: context, title: getTranslated('delivery_address', context)),
      body: SingleChildScrollView(
        physics: ResponsiveHelper.isDesktop(context)
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_SMALL : 0),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_SMALL : 0),
                  decoration: ResponsiveHelper.isDesktop(context)
                      ? BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 1)],
                        )
                      : null,
                  height: ResponsiveHelper.isDesktop(context)
                      ? MediaQuery.of(context).size.height * 0.7
                      : MediaQuery.of(context).size.height * 0.9,
                  width: Dimensions.WEB_SCREEN_WIDTH,
                  child: Stack(children: [
                    GoogleMap(
                      minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                      initialCameraPosition: CameraPosition(target: _latLng, zoom: 14),
                      zoomGesturesEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      indoorViewEnabled: true,
                      markers: _markers,
                    ),
                    Positioned(
                      left: Dimensions.PADDING_SIZE_LARGE,
                      right: Dimensions.PADDING_SIZE_LARGE,
                      bottom: Dimensions.PADDING_SIZE_LARGE,
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).cardColor,
                          boxShadow: [BoxShadow(color: Colors.grey.shade300, spreadRadius: 3, blurRadius: 10)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(
                                widget.address.addressType == 'Home'
                                    ? Icons.home_outlined
                                    : widget.address.addressType == 'Workplace'
                                        ? Icons.work_outline
                                        : Icons.list_alt_outlined,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(widget.address.addressType,
                                          style: rubikRegular.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_SMALL,
                                            color: ColorResources.getGreyBunkerColor(context),
                                          )),
                                      Text(widget.address.address, style: rubikMedium),
                                    ]),
                              ),
                            ]),
                            Text('- ${widget.address.contactPersonName}',
                                style: rubikMedium.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                )),
                            Text('- ${widget.address.contactPersonNumber}', style: rubikRegular),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            if (ResponsiveHelper.isDesktop(context)) const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            if (ResponsiveHelper.isDesktop(context)) const FooterView(),
          ],
        ),
      ),
    );
  }

  void _setMarker() async {
    Uint8List destinationImageData = await convertAssetToUnit8List(Images.destination_marker, width: 70);

    _markers = {};
    _markers.add(
      Marker(
        markerId: const MarkerId('marker'),
        position: _latLng,
        icon: BitmapDescriptor.bytes(destinationImageData),
      ),
    );

    setState(() {});
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }
}
