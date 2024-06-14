import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/product_type.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/banner_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/category_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/localization_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/profile_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/wishlist_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/title_widget.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/category_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/product_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/menu/widget/options_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../base/custom_app_bar.dart';
import '../../base/product_widget.dart';

// class HomeScreen extends StatefulWidget {
//   final bool fromAppBar;
//
//   HomeScreen(this.fromAppBar);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
//   final ScrollController _scrollController = ScrollController();
//
//   Future<void> _loadData(BuildContext context, bool reload) async {
//     if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
//       Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
//
//       await Provider.of<WishListProvider>(context, listen: false).initWishList(
//         context,
//         Provider.of<LocalizationProvider>(context, listen: false)
//             .locale
//             .languageCode,
//       );
//     }
//
//     if (reload) {
//       Provider.of<ProductProvider>(context, listen: false).getLatestProductList(
//         context,
//         false,
//         '1',
//         Provider.of<LocalizationProvider>(context, listen: false)
//             .locale
//             .languageCode,
//       );
//
//       Provider.of<ProductProvider>(context, listen: false)
//           .getPopularProductList(
//         context,
//         false,
//         '1',
//       );
//
//       Provider.of<SplashProvider>(context, listen: false)
//           .getPolicyPage(context);
//
//       Provider.of<ProductProvider>(context, listen: false).seeMoreReturn();
//
//       Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
//         context,
//         true,
//         Provider.of<LocalizationProvider>(context, listen: false)
//             .locale
//             .languageCode,
//       );
//
//       Provider.of<SetMenuProvider>(context, listen: false).getSetMenuList(
//         context,
//         reload,
//         Provider.of<LocalizationProvider>(context, listen: false)
//             .locale
//             .languageCode,
//       );
//
//       Provider.of<BannerProvider>(context, listen: false)
//           .getBannerList(context, reload);
//     } else {
//       Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
//         context,
//         true,
//         Provider.of<LocalizationProvider>(context, listen: false)
//             .locale
//             .languageCode,
//       );
//
//       Provider.of<SetMenuProvider>(context, listen: false).getSetMenuList(
//         context,
//         reload,
//         Provider.of<LocalizationProvider>(context, listen: false)
//             .locale
//             .languageCode,
//       );
//
//       Provider.of<BannerProvider>(context, listen: false)
//           .getBannerList(context, reload);
//     }
//   }
//
//   @override
//   void initState() {
//     Provider.of<ProductProvider>(context, listen: false).seeMoreReturn();
//     if (!widget.fromAppBar ||
//         Provider.of<CategoryProvider>(context, listen: false).categoryList ==
//             null) {
//       _loadData(context, false);
//     }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: drawerGlobalKey,
//       endDrawerEnableOpenDragGesture: false,
//       backgroundColor: Theme.of(context).backgroundColor,
//       drawer: ResponsiveHelper.isTab(context)
//           ? Drawer(child: OptionsView(onTap: null))
//           : SizedBox(),
//
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () async {
//             Provider.of<OrderProvider>(context, listen: false)
//                 .changeStatus(true, notify: true);
//             Provider.of<ProductProvider>(context, listen: false).latestOffset =
//                 1;
//             Provider.of<SplashProvider>(context, listen: false)
//                 .initConfig(context)
//                 .then((value) {
//               if (value) {
//                 _loadData(context, true);
//               }
//             });
//           },
//           backgroundColor: Theme.of(context).primaryColor,
//           child:  Stack(
//                   children: [
//                     _scrollView(_scrollController, context),
//                     Consumer<SplashProvider>(
//                         builder: (context, splashProvider, _) {
//                       return !splashProvider.isRestaurantOpenNow(context)
//                           ? Positioned(
//                               bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
//                               left: 0,
//                               right: 0,
//                               child: Consumer<OrderProvider>(
//                                 builder: (context, orderProvider, _) {
//                                   return orderProvider.isRestaurantCloseShow
//                                       ? Container(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: Dimensions
//                                                   .PADDING_SIZE_EXTRA_SMALL),
//                                           alignment: Alignment.center,
//                                           color: Theme.of(context)
//                                               .primaryColor
//                                               .withOpacity(0.9),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets
//                                                         .symmetric(
//                                                     horizontal: Dimensions
//                                                         .PADDING_SIZE_DEFAULT),
//                                                 child: Text(
//                                                   '${'${getTranslated('restaurant_is_close_now', context)}'}',
//                                                   style: rubikRegular.copyWith(
//                                                       fontSize: 12,
//                                                       color: Colors.white),
//                                                 ),
//                                               ),
//                                               InkWell(
//                                                 onTap: () => orderProvider
//                                                     .changeStatus(false,
//                                                         notify: true),
//                                                 child: Padding(
//                                                   padding: const EdgeInsets
//                                                           .symmetric(
//                                                       horizontal: Dimensions
//                                                           .PADDING_SIZE_SMALL),
//                                                   child: Icon(
//                                                       Icons.cancel_outlined,
//                                                       color: Colors.white,
//                                                       size: Dimensions
//                                                           .PADDING_SIZE_LARGE),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         )
//                                       : SizedBox();
//                                 },
//                               ),
//                             )
//                           : SizedBox();
//                     })
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }
//
//   Scrollbar _scrollView(
//       ScrollController _scrollController, BuildContext context) {
//     return Scrollbar(
//       controller: _scrollController,
//       child: CustomScrollView(controller: _scrollController, slivers: [
//         // AppBar
//
//         SliverAppBar(
//                 floating: true,
//                 elevation: 0,
//                 centerTitle: false,
//                 automaticallyImplyLeading: false,
//                 backgroundColor: Theme.of(context).cardColor,
//                 pinned: ResponsiveHelper.isTab(context) ? true : true,
//                 leading: ResponsiveHelper.isTab(context)|| ResponsiveHelper.isWeb()
//                     ? IconButton(
//                         onPressed: () =>
//                             drawerGlobalKey.currentState.openDrawer(),
//                         icon: Icon(Icons.menu, color:Theme.of(context).textTheme.bodyText1.color),
//                       )
//                     : null,
//                 title: Consumer<SplashProvider>(
//                     builder: (context, splash, child) => Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             ResponsiveHelper.isWeb()
//                                 ? FadeInImage.assetNetwork(
//                                     placeholder: Images.placeholder_rectangle,
//                                     height: 40,
//                                     width: 40,
//                                     image: splash.baseUrls != null
//                                         ? '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}'
//                                         : '',
//                                     imageErrorBuilder: (c, o, s) => Image.asset(
//                                         Images.placeholder_rectangle,
//                                         height: 40,
//                                         width: 40),
//                                   )
//                                 : Image.asset(Images.logo,
//                                     width: 40, height: 40),
//                             SizedBox(width: 10),
//                             // Expanded(
//                             //   child: Text(
//                             //     ResponsiveHelper.isWeb() ? splash.configModel.restaurantName : AppConstants.APP_NAME,
//                             //     style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
//                             //     maxLines: 1, overflow: TextOverflow.ellipsis,
//                             //   ),
//                             // ),
//                           ],
//                         )),
//                 actions: [
//                   ResponsiveHelper.isTab(context)|| ResponsiveHelper.isWeb()?   SizedBox(): IconButton(
//                     onPressed: () => Navigator.push(
//                         context, MaterialPageRoute(builder: (context)=>MenuScreen())),
//                     icon: Icon(Icons.menu,
//                         color: Theme.of(context).textTheme.bodyText1.color),
//                   ) ,
//                   ResponsiveHelper.isTab(context)|| ResponsiveHelper.isWeb()
//                       ? IconButton(
//                           onPressed: () => Navigator.pushNamed(
//                               context, Routes.getDashboardRoute('cart')),
//                           icon: Stack(
//                             clipBehavior: Clip.none,
//                             children: [
//                               Icon(Icons.shopping_cart,
//                                   color: Theme.of(context)
//                                       .textTheme
//                                       .bodyText1
//                                       .color),
//                               Positioned(
//                                 top: -10,
//                                 right: -10,
//                                 child: Container(
//                                   padding: EdgeInsets.all(4),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.red),
//                                   child: Center(
//                                     child: Text(
//                                       Provider.of<CartProvider>(context)
//                                           .cartList
//                                           .length
//                                           .toString(),
//                                       style: rubikMedium.copyWith(
//                                           color: Colors.white, fontSize: 8),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : SizedBox(),
//                 ],
//               ),
//
//         // Search Button
//         // if(!ResponsiveHelper.isDesktop(context))  SliverPersistentHeader(
//         //    pinned: true,
//         //    delegate: SliverDelegate(child: Center(
//         //      child: InkWell(
//         //        onTap: () => Navigator.pushNamed(context, Routes.getSearchRoute()),
//         //        child: Container(
//         //          height: 60, width: 1170,
//         //          color: Theme.of(context).cardColor,
//         //          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 5),
//         //          child: Container(
//         //            decoration: BoxDecoration(color: ColorResources.getSearchBg(context), borderRadius: BorderRadius.circular(10)),
//         //            child: Row(children: [
//         //              Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL), child: Icon(Icons.search, size: 25)),
//         //              Expanded(child: Text(getTranslated('search_items_here', context), style: rubikRegular.copyWith(fontSize: 12))),
//         //            ]),
//         //          ),
//         //        ),
//         //      ),
//         //    )),
//         //  ),
//
//         SliverToBoxAdapter(
//           child: Center(
//             child: Column(
//               children: [
//                 SizedBox(
//                   width: 1170,
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//
//
//
//                         Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: CategoryView(),
//                               ),
//                         // Expanded(
//                         //   child: Container(
//                         //
//                         //
//                         //       child: MenuPage(title: 'Home',)),
//                         // ),
//
//                       //   ResponsiveHelper.isDesktop(context)? SetMenuViewWeb() :  SetMenuView(),
//
//
//                         Padding(
//                                 padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
//                                 child: TitleWidget(
//                                   title: 'POPULAR ITEMS',
//
//                                   //   onTap: (){
//                                   //   Navigator.pushNamed(context, Routes.getPopularItemScreen());
//                                   // },
//                                 ),
//                               ),
//                         ProductView(
//                           productType: ProductType.POPULAR_PRODUCT,
//                         ),
//                       BannerView(),
//                      Padding(
//                           padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
//                           child: TitleWidget(
//                             title:'SPECIAL OFFERS',
//
//                             //   onTap: (){
//                             //   Navigator.pushNamed(context, Routes.getPopularItemScreen());
//                             // },
//                           ),
//                         ),
//                         ProductView(
//                           productType: ProductType.POPULAR_PRODUCT,
//                           isBuffet: true,
//                         ),
//
//                         ProducCatView(
//                             productType: ProductType.LATEST_PRODUCT,
//                             scrollController: _scrollController),
//                       ]),
//                 ),
//                FooterView(),
//               ],
//             ),
//           ),
//         ),
//         //  if(ResponsiveHelper.isDesktop(context)) FooterView(),
//       ]),
//     );
//   }
// }
// //ResponsiveHelper

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 60 || oldDelegate.minExtent != 60 || child != oldDelegate.child;
  }
}

/// old code
class HomeScreen extends StatefulWidget {
  final bool fromAppBar;

  HomeScreen(this.fromAppBar);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Future<void> loadData(bool reload) async {
    if (Provider.of<AuthProvider>(Get.context, listen: false).isLoggedIn()) {
      Provider.of<ProfileProvider>(Get.context, listen: false).getUserInfo(Get.context);

      await Provider.of<WishListProvider>(Get.context, listen: false).initWishList(
        Get.context,
        Provider.of<LocalizationProvider>(Get.context, listen: false).locale.languageCode,
      );
    }

    if (reload) {
      Provider.of<AllCategoryProvider>(Get.context, listen: false).getCategoryList(
        Get.context,
        false,
        Provider.of<LocalizationProvider>(Get.context, listen: false).locale.languageCode,
      );
      Provider.of<ProductProvider>(Get.context, listen: false).getPopularProductList(
        Get.context,
        false,
        '1',
      );

      Provider.of<SplashProvider>(Get.context, listen: false).getPolicyPage(Get.context);

      Provider.of<ProductProvider>(Get.context, listen: false).getRecommendedBeveragesList(Get.context);
      Provider.of<ProductProvider>(Get.context, listen: false).getRecommendedSideList(Get.context);

      Provider.of<CategoryProvider>(Get.context, listen: false).getCategoryList(
        Get.context,
        true,
        Provider.of<LocalizationProvider>(Get.context, listen: false).locale.languageCode,
      );

      Provider.of<BannerProvider>(Get.context, listen: false).getBannerList(Get.context, reload);
    } else {
      Provider.of<AllCategoryProvider>(Get.context, listen: false).getCategoryList(
        Get.context,
        false,
        Provider.of<LocalizationProvider>(Get.context, listen: false).locale.languageCode,
      );
      Provider.of<ProductProvider>(Get.context, listen: false).getPopularProductList(
        Get.context,
        false,
        '1',
      );

      Provider.of<SplashProvider>(Get.context, listen: false).getPolicyPage(Get.context);

      Provider.of<ProductProvider>(Get.context, listen: false).getRecommendedBeveragesList(Get.context);
      Provider.of<ProductProvider>(Get.context, listen: false).getRecommendedSideList(Get.context);

      Provider.of<CategoryProvider>(Get.context, listen: false).getCategoryList(
        Get.context,
        true,
        Provider.of<LocalizationProvider>(Get.context, listen: false).locale.languageCode,
      );

      Provider.of<BannerProvider>(Get.context, listen: false).getBannerList(Get.context, reload);
    }
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  bool _isLoggedIn = false;

  Future<void> _loadData(BuildContext context, bool reload) async {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      _isLoggedIn = true;
    }

    if (reload) {
      Provider.of<AllCategoryProvider>(context, listen: false).getCategoryList(
        context,
        false,
        Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      );
      Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
        context,
        false,
        '1',
      );

      Provider.of<SplashProvider>(context, listen: false).getPolicyPage(context);

      Provider.of<ProductProvider>(context, listen: false).getRecommendedBeveragesList(context);
      Provider.of<ProductProvider>(context, listen: false).getRecommendedSideList(context);

      Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
        context,
        true,
        Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      );

      // Provider.of<BannerProvider>(context, listen: false)
      //     .getBannerList(context, reload);
    } else {
      Provider.of<AllCategoryProvider>(context, listen: false).getCategoryList(
        context,
        false,
        Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      );
      Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
        context,
        false,
        '1',
      );

      Provider.of<SplashProvider>(context, listen: false).getPolicyPage(context);

      Provider.of<ProductProvider>(context, listen: false).getRecommendedBeveragesList(context);
      Provider.of<ProductProvider>(context, listen: false).getRecommendedSideList(context);

      Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
        context,
        true,
        Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      );

      Provider.of<BannerProvider>(context, listen: false).getBannerList(context, reload);
    }
  }

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).seeMoreReturn();
    if (!widget.fromAppBar || Provider.of<CategoryProvider>(context, listen: false).categoryList == null) {
      _loadData(context, false);
    }
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor:
          ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : Theme.of(context).backgroundColor,
      drawer: ResponsiveHelper.isTab(context) ? Drawer(child: OptionsView(onTap: null)) : SizedBox(),
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100))
          : null,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            Provider.of<OrderProvider>(context, listen: false).changeStatus(true, notify: true);
            Provider.of<ProductProvider>(context, listen: false).latestOffset = 1;
            Provider.of<SplashProvider>(context, listen: false).initConfig(context).then((value) {
              if (value) {
                _loadData(context, true);
              }
            });
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: ResponsiveHelper.isDesktop(context)
              ? _scrollView(_scrollController, context)
              : Stack(
                  children: [
                    _scrollView(_scrollController, context),
                    Consumer<SplashProvider>(builder: (context, splashProvider, _) {
                      return !splashProvider.isRestaurantOpenNow(context)
                          ? Positioned(
                              bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                              left: 0,
                              right: 0,
                              child: Consumer<OrderProvider>(
                                builder: (context, orderProvider, _) {
                                  return orderProvider.isRestaurantCloseShow
                                      ? Container(
                                          padding:
                                              const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                          alignment: Alignment.center,
                                          color: Theme.of(context).primaryColor.withOpacity(0.9),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                                child: Text(
                                                  '${'${getTranslated('restaurant_is_close_now', context)}'}',
                                                  style: rubikRegular.copyWith(fontSize: 12, color: Colors.white),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => orderProvider.changeStatus(false, notify: true),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                                                  child: Icon(Icons.cancel_outlined,
                                                      color: Colors.white, size: Dimensions.PADDING_SIZE_LARGE),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox();
                                },
                              ),
                            )
                          : SizedBox();
                    })
                  ],
                ),
        ),
      ),
    );
  }

  Scrollbar _scrollView(ScrollController _scrollController, BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: CustomScrollView(controller: _scrollController, slivers: [
        // AppBar
        ResponsiveHelper.isDesktop(context)
            ? SliverToBoxAdapter(child: SizedBox())
            : SliverAppBar(
                floating: true,
                elevation: 0,
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).cardColor,
                pinned: ResponsiveHelper.isTab(context) ? true : true,
                leading: ResponsiveHelper.isTab(context)
                    ? IconButton(
                        onPressed: () => drawerGlobalKey.currentState.openDrawer(),
                        icon: Icon(Icons.menu, color: Theme.of(context).textTheme.bodyText1.color),
                      )
                    : null,
                title: Text('Food Menu',
                    style: rubikMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).textTheme.bodyText1.color)),
                // Consumer<SplashProvider>(
                //     builder: (context, splash, child) =>
                //         Consumer<ProfileProvider>(
                //             builder: (context, profile, child) {
                //               return Row(
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   ResponsiveHelper.isWeb()
                //                       ? FadeInImage.assetNetwork(
                //                     placeholder: Images.placeholder_rectangle,
                //                     height: 40,
                //                     width: 40,
                //                     image: splash.baseUrls != null
                //                         ? '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}'
                //                         : '',
                //                     imageErrorBuilder: (c, o, s) =>
                //                         Image.asset(
                //                             Images.placeholder_rectangle,
                //                             height: 40,
                //                             width: 40),
                //                   )
                //                       : Image.asset(Images.logo,
                //                       width: 40, height: 40),
                //                   SizedBox(width: 10),
                //                   _isLoggedIn && profile.userInfoModel != null
                //                       ? Expanded(
                //                     child: Row(
                //                       children: [
                //                         Text(
                //                           '${getGreetingMessage()}, ${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName ?? ''}',
                //                           style: rubikBold.copyWith(
                //                               color: Theme.of(context)
                //                                   .primaryColor),
                //                           maxLines: 1,
                //                           overflow: TextOverflow.ellipsis,
                //                         ),
                //                         SizedBox(
                //                           width: 10,
                //                         ),
                //                         Image.asset(
                //                           getGreetingIcons(),
                //                           height: 25,
                //                         ),
                //                       ],
                //                     ),
                //                   )
                //                       : SizedBox(),
                //                 ],
                //               );
                //             })),
                // actions: [
                //   ResponsiveHelper.isTab(context)
                //       ? SizedBox()
                //       : IconButton(
                //     onPressed: () => Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => MenuScreen())),
                //     icon: Icon(Icons.menu,
                //         color:
                //         Theme.of(context).textTheme.bodyText1.color),
                //   ),
                //   ResponsiveHelper.isTab(context)
                //       ? IconButton(
                //     onPressed: () => Navigator.pushNamed(
                //         context, Routes.getDashboardRoute('cart')),
                //     icon: Stack(
                //       clipBehavior: Clip.none,
                //       children: [
                //         Icon(Icons.shopping_cart,
                //             color: Theme.of(context)
                //                 .textTheme
                //                 .bodyText1
                //                 .color),
                //         Positioned(
                //           top: -10,
                //           right: -10,
                //           child: Container(
                //             padding: EdgeInsets.all(4),
                //             alignment: Alignment.center,
                //             decoration: BoxDecoration(
                //                 shape: BoxShape.circle,
                //                 color: Colors.red),
                //             child: Center(
                //               child: Text(
                //                 (Provider.of<CartProvider>(context)
                //                     .cartList
                //                     .length +
                //                     Provider.of<CartProvider>(context)
                //                         .cateringList
                //                         .length +
                //                     Provider.of<CartProvider>(context)
                //                         .happyHoursList
                //                         .length)
                //                     .toString(),
                //                 style: rubikMedium.copyWith(
                //                     color: Colors.white, fontSize: 8),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   )
                //       : SizedBox(),
                // ],
              ),

        // Search Button
        // if(!ResponsiveHelper.isDesktop(context))  SliverPersistentHeader(
        //    pinned: true,
        //    delegate: SliverDelegate(child: Center(
        //      child: InkWell(
        //        onTap: () => Navigator.pushNamed(context, Routes.getSearchRoute()),
        //        child: Container(
        //          height: 60, width: 1170,
        //          color: Theme.of(context).cardColor,
        //          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 5),
        //          child: Container(
        //            decoration: BoxDecoration(color: ColorResources.getSearchBg(context), borderRadius: BorderRadius.circular(10)),
        //            child: Row(children: [
        //              Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL), child: Icon(Icons.search, size: 25)),
        //              Expanded(child: Text(getTranslated('search_items_here', context), style: rubikRegular.copyWith(fontSize: 12))),
        //            ]),
        //          ),
        //        ),
        //      ),
        //    )),
        //  ),

        SliverToBoxAdapter(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: 1170,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // ResponsiveHelper.isDesktop(context)
                    //     ? CategoryViewWeb()
                    //     :
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CategoryView(),
                    ),

                    ///Popular Items
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TitleWidget(
                        title: 'POPULAR ITEMS',

                        //   onTap: (){
                        //   Navigator.pushNamed(context, Routes.getPopularItemScreen());
                        // },
                      ),
                    ),
                    ProductView(
                      productType: ProductType.POPULAR_PRODUCT,
                    ),

                    ///special offers
                    // BannerView(),
                    //
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    //   child: TitleWidget(
                    //     title: 'SPECIAL OFFERS',
                    //
                    //     //   onTap: (){
                    //     //   Navigator.pushNamed(context, Routes.getPopularItemScreen());
                    //     // },
                    //   ),
                    // ),
                    //
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //   child: SpecialOffersView(),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    //
                    //
                    ProducCatView(productType: ProductType.LATEST_PRODUCT, scrollController: _scrollController),
                  ]),
                ),
                if (ResponsiveHelper.isDesktop(context)) FooterView(),
              ],
            ),
          ),
        ),
        //  if(ResponsiveHelper.isDesktop(context)) FooterView(),
      ]),
    );
  }
}

class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final scrollDirection = Axis.vertical;

  AutoScrollController controller;
  AutoScrollController controller1;
  List<List<int>> randomList;

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    controller1 = AutoScrollController(
        viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(context: context, title: 'Food Menu', isBackButtonExist: false),
        body: Consumer<AllCategoryProvider>(builder: (context, category, child) {
          Provider.of<CartProvider>(context).setFalse();

          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 80, // Set a fixed height for the horizontal ListView
                child: ListView.builder(
                  controller: controller1,
                  scrollDirection: Axis.horizontal,
                  itemCount: category.categoryList.length,
                  padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                      child: InkWell(
                        onTap: () {
                          _scrollToIndex(index);
                        },
                        child: Column(children: [
                          ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder_image, width: 65, height: 65, fit: BoxFit.cover,
                              image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                                  ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${category.categoryList[index].image}'
                                  : '',
                              imageErrorBuilder: (c, o, s) =>
                                  Image.asset(Images.placeholder_image, width: 65, height: 65, fit: BoxFit.cover),
                              // width: 100, height: 100, fit: BoxFit.cover,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              category.categoryList[index].name,
                              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: scrollDirection,
                  shrinkWrap: true,
                  itemCount: category.categoryList.length,
                  controller: controller,
                  itemBuilder: (context, index) {
                    return AutoScrollTag(
                      key: ValueKey(index),
                      controller: controller,
                      index: index,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                category.categoryList[index].name,
                                style: rubikMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                ),
                              ),
                            ),
                            ...List.generate(category.categoryList[index].products.length, (ind) {
                              return Padding(
                                padding:

                                    ///with lines
                                    EdgeInsets.zero,

                                ///with out lines

                                //const EdgeInsets.symmetric(vertical: 4),
                                child: ProductWidget(
                                  product: category.categoryList[index].products[ind],
                                  isFromPoinst: false,
                                  //   isLined: true,//for lines,
                                  //   isLast: ind==category.categoryList[index].products.length-1||category.categoryList[index].products.length==1,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }));
  }

  Future _scrollToIndex(index) async {
    await controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
    await controller1.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
  }
}
