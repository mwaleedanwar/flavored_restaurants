import 'dart:developer';

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
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/home_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/modified_home_page.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/menu/menu_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/order/order_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

import '../../../provider/branch_provider.dart';
import '../../../provider/category_provider.dart';
import '../../../provider/coupon_provider.dart';
import '../../../provider/splash_provider.dart';
import '../../../utill/images.dart';
import '../../gitft_dialog/gift_dialog.dart';
import '../heart_points/heart_points.dart';
import '../home/new_home.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;

  const DashboardScreen({Key key, @required this.pageIndex}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    print('===branch id:${Provider.of<BranchProvider>(context, listen: false).getBranchId()}');
    Provider.of<BranchProvider>(context, listen: false).setCurrentId();
    print('===branch dash id:${Provider.of<BranchProvider>(context, listen: false).branch}');
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
    Provider.of<ProductProvider>(context, listen: false).getSpecialOffersList(context);
    Provider.of<ProductProvider>(context, listen: false).getDealsList(context);

    Provider.of<OrderProvider>(context, listen: false).changeStatus(true);
    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      ModifiedHomePage(),

      ///version 1
      // MenuPage(),
      TestMenuScreen(),

      ///version 2
      // MyHomePage(),
      ///version 3

      // HomeScreen(false),

      CartScreen(),
      OrderScreen(),
      // WishListScreen(),
      HeartPointScreen()
      // MenuScreen(onTap: (int pageIndex) {
      //   _setPage(pageIndex);
      // }),
    ];

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
    await Future.delayed(Duration(milliseconds: 50));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => GiftDialog(
              couponModel: Provider.of<CouponProvider>(context, listen: false).gift,
            ));
  }

  _showWelcomDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    showDialog(context: context, barrierDismissible: false, builder: (context) => WelcomeMessageDialog());
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
            : SizedBox(),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(IconData icon, String label, int index, {bool isImage = false, String path}) {
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          isImage
              ? Image.asset(path,
                  height: 27, color: index == _pageIndex ? Theme.of(context).primaryColor : ColorResources.COLOR_GREY)
              : Icon(icon,
                  color: index == _pageIndex ? Theme.of(context).primaryColor : ColorResources.COLOR_GREY, size: 25),
          index == 2
              ? Positioned(
                  top: -7,
                  right: -7,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
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
              : SizedBox(),
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
