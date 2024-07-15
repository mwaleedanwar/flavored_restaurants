// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/coupon_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/no_data_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/not_logged_in_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  late bool _isLoggedIn;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<CouponProvider>(context, listen: false).getCouponList(context);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : CustomAppBar(context: context, title: getTranslated('coupon', context)),
      body: loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : _isLoggedIn
              ? Consumer<CouponProvider>(
                  builder: (context, coupon, child) {
                    return coupon.couponList.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: () async {
                              await Provider.of<CouponProvider>(context, listen: false).getCouponList(context);
                            },
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Center(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            minHeight: !ResponsiveHelper.isDesktop(context) &&
                                                    MediaQuery.of(context).size.height < 600
                                                ? MediaQuery.of(context).size.height
                                                : MediaQuery.of(context).size.height - 400),
                                        child: Container(
                                          padding: MediaQuery.of(context).size.width > 700
                                              ? const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE)
                                              : EdgeInsets.zero,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width > 700
                                                ? 700
                                                : MediaQuery.of(context).size.width,
                                            padding: MediaQuery.of(context).size.width > 700
                                                ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                                                : null,
                                            decoration: MediaQuery.of(context).size.width > 700
                                                ? BoxDecoration(
                                                    color: Theme.of(context).cardColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 1)
                                                    ],
                                                  )
                                                : null,
                                            child: ListView.builder(
                                              itemCount: coupon.couponList.length,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_LARGE),
                                                  child: InkWell(
                                                    onTap: () {
                                                      coupon.couponList[index].isExpired == true
                                                          ? null
                                                          : Clipboard.setData(
                                                              ClipboardData(text: coupon.couponList[index].code));
                                                      coupon.couponList[index].isExpired == true
                                                          ? showCustomSnackBar('Coupon Expired', context,
                                                              isError: false)
                                                          : showCustomSnackBar(
                                                              getTranslated('coupon_code_copied', context), context,
                                                              isError: false);
                                                    },
                                                    child: Stack(children: [
                                                      Image.asset(Images.coupon_bg,
                                                          height: 100,
                                                          width: 1170,
                                                          fit: BoxFit.fitWidth,
                                                          color: coupon.couponList[index].isExpired == true
                                                              ? Colors.grey
                                                              : Theme.of(context).primaryColor),
                                                      Container(
                                                        height: 100,
                                                        alignment: Alignment.center,
                                                        child: Row(children: [
                                                          const SizedBox(width: 50),
                                                          Image.asset(Images.percentage, height: 50, width: 50),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(
                                                                horizontal: Dimensions.PADDING_SIZE_LARGE,
                                                                vertical: Dimensions.PADDING_SIZE_SMALL),
                                                            child: Image.asset(Images.line, height: 100, width: 5),
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    coupon.couponList[index].title,
                                                                    style: rubikMedium.copyWith(
                                                                      color: ColorResources.COLOR_WHITE,
                                                                      fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                                  SelectableText(
                                                                    coupon.couponList[index].code,
                                                                    style: rubikRegular.copyWith(
                                                                        color: ColorResources.COLOR_WHITE),
                                                                  ),
                                                                  const SizedBox(
                                                                      height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                                  coupon.couponList[index].discountType == 'product'
                                                                      ? Text(
                                                                          '${coupon.couponList[index].product!.name}',
                                                                          style: rubikMedium.copyWith(
                                                                              color: ColorResources.COLOR_WHITE,
                                                                              fontSize:
                                                                                  Dimensions.FONT_SIZE_EXTRA_LARGE),
                                                                        )
                                                                      : Text(
                                                                          '${coupon.couponList[index].discount}${coupon.couponList[index].discountType == 'percent' ? '%' : Provider.of<SplashProvider>(context, listen: false).configModel!.currencySymbol} off',
                                                                          style: rubikMedium.copyWith(
                                                                              color: ColorResources.COLOR_WHITE,
                                                                              fontSize:
                                                                                  Dimensions.FONT_SIZE_EXTRA_LARGE),
                                                                        ),
                                                                  const SizedBox(
                                                                      height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                                  Text(
                                                                    '${getTranslated('valid_until', context)} ${DateConverter.isoStringToLocalDateOnly(coupon.couponList[index].expireDate)}',
                                                                    style: rubikRegular.copyWith(
                                                                        color: ColorResources.COLOR_WHITE,
                                                                        fontSize: Dimensions.FONT_SIZE_SMALL),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ]),
                                                      ),
                                                    ]),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (ResponsiveHelper.isDesktop(context)) const FooterView()
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const NoDataScreen();
                  },
                )
              : const NotLoggedInScreen(),
    );
  }
}
