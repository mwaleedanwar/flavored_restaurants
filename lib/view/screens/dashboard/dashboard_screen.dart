// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/network_info.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/localization_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/cart/cart_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/modified_home_page.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/order/order_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/branch_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/category_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/coupon_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/gitft_dialog/gift_dialog.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/heart_points/heart_points.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/new_home.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;

  const DashboardScreen({super.key, required this.pageIndex});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final _pageController = PageController();
  int _pageIndex = 0;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    debugPrint('===branch id:${Provider.of<BranchProvider>(context, listen: false).getBranchId}');
    Provider.of<BranchProvider>(context, listen: false).setCurrentId();
    debugPrint('===branch dash id:${Provider.of<BranchProvider>(context, listen: false).branch}');
    Provider.of<AllCategoryProvider>(context, listen: false).getCategoryList(
      context,
      false,
      Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );

    if (Provider.of<SplashProvider>(context, listen: false).policyModel == null) {
      Provider.of<SplashProvider>(context, listen: false).getPolicyPage(context);
    }
    Provider.of<ProductProvider>(context, listen: false).getLatestProductList(
      context,
      false,
      '1',
      Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
    );

    Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
      context,
      false,
      '1',
    );

    Provider.of<OrderProvider>(context, listen: false).changeStatus(true);
    _pageIndex = widget.pageIndex;

    if (ResponsiveHelper.isMobilePhone()) {
      NetworkInfo.checkConnectivity(_scaffoldKey);
    }
    // _showWelcomDialog();

    if (Provider.of<AuthProvider>(context, listen: false).isSignUp) {
      _showWelcomDialog();
    }
    Provider.of<AuthProvider>(context, listen: false).resetSignUp();
    Provider.of<CouponProvider>(context, listen: false).gift != null ? _showDialog() : null;
  }

  _showDialog() async {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => GiftDialog(
              couponModel: Provider.of<CouponProvider>(context, listen: false).gift!,
            ));
  }

  _showWelcomDialog() async {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog(context: context, barrierDismissible: false, builder: (context) => const WelcomeMessageDialog());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: ResponsiveHelper.isMobile(context)
            ? BottomNavigationBar(
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: ColorResources.COLOR_GREY,
                showUnselectedLabels: true,
                currentIndex: _pageIndex,
                type: BottomNavigationBarType.fixed,
                items: [
                  _barItem(Icons.home, getTranslated('home', context), 0),
                  _barItem(Icons.restaurant_menu, 'Menu', 1),
                  _barItem(Icons.shopping_cart, getTranslated('cart', context), 2),
                  _barItem(Icons.shopping_bag, 'Orders', 3),
                  _barItem(Icons.cloud_upload_rounded, 'Rewards', 4, isImage: true, path: Images.trophy)
                ],
                onTap: (int index) {
                  _setPage(index);
                },
              )
            : const SizedBox(),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ModifiedHomePage(
              navigateToMenu: () => _setPage(1),
              navigateToReward: () => _setPage(4),
            ),
            const TestMenuScreen(),
            const CartScreen(),
            const OrderScreen(),
            const HeartPointScreen(),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(IconData icon, String label, int index, {bool isImage = false, String? path}) {
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          isImage
              ? Image.asset(path!,
                  height: 27, color: index == _pageIndex ? Theme.of(context).primaryColor : ColorResources.COLOR_GREY)
              : Icon(icon,
                  color: index == _pageIndex ? Theme.of(context).primaryColor : ColorResources.COLOR_GREY, size: 25),
          index == 2
              ? Positioned(
                  top: -7,
                  right: -7,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                    child: Text(
                      (Provider.of<CartProvider>(context).cartList.length +
                              Provider.of<CartProvider>(context).cateringList.length +
                              Provider.of<CartProvider>(context).happyHoursList.length +
                              Provider.of<CartProvider>(context).dealsList.length)
                          .toString(),
                      style: rubikMedium.copyWith(color: ColorResources.COLOR_WHITE, fontSize: 8),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
