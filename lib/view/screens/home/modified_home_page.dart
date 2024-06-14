import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/localization_provider.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/provider/profile_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/wishlist_provider.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/config_model.dart';
import '../../../helper/salutations_function.dart';
import '../../../localization/language_constrants.dart';
import '../../base/custom_button.dart';
import '../heart_points/widgets/progress_with_dots.dart';
import '../menu/menu_screen.dart';

class ModifiedHomePage extends StatefulWidget {
  const ModifiedHomePage({Key key}) : super(key: key);

  @override
  State<ModifiedHomePage> createState() => _ModifiedHomePageState();
}

class _ModifiedHomePageState extends State<ModifiedHomePage> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  bool _isLoggedIn = false;
  double points = 0;

  Future<void> _loadData(BuildContext context, bool reload) async {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      _isLoggedIn = true;

      if (_isLoggedIn) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context).then((value) {
          if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel.point != null) {
            points = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.point.toDouble();
            setState(() {});
          }
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          leading: ResponsiveHelper.isTab(context)
              ? IconButton(
                  onPressed: () => drawerGlobalKey.currentState.openDrawer(),
                  icon: Icon(Icons.menu, color: Theme.of(context).textTheme.bodyText1.color),
                )
              : null,
          backgroundColor: Theme.of(context).cardColor,
          title: Consumer<SplashProvider>(
              builder: (context, splash, child) => Consumer<ProfileProvider>(builder: (context, profile, child) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ResponsiveHelper.isWeb()
                            ? FadeInImage.assetNetwork(
                                placeholder: Images.placeholder_rectangle,
                                height: 40,
                                width: 40,
                                image: splash.baseUrls != null
                                    ? '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}'
                                    : '',
                                imageErrorBuilder: (c, o, s) =>
                                    Image.asset(Images.placeholder_rectangle, height: 40, width: 40),
                              )
                            : Image.asset(F.logo, width: 40, height: 40),
                        SizedBox(width: 10),
                        _isLoggedIn && profile.userInfoModel != null
                            ? Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      '${getGreetingMessage()}, ${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName ?? ''}',
                                      style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      getGreetingIcons(),
                                      height: 25,
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                      ],
                    );
                  })),
          actions: [
            ResponsiveHelper.isTab(context)
                ? SizedBox()
                : IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MenuScreen())),
                    icon: Icon(Icons.menu, color: Theme.of(context).textTheme.bodyText1.color),
                  ),
            ResponsiveHelper.isTab(context)
                ? IconButton(
                    onPressed: () => Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(Icons.shopping_cart, color: Theme.of(context).textTheme.bodyText1.color),
                        Positioned(
                          top: -10,
                          right: -10,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                            child: Center(
                              child: Text(
                                (Provider.of<CartProvider>(context).cartList.length +
                                        Provider.of<CartProvider>(context).cateringList.length +
                                        Provider.of<CartProvider>(context).happyHoursList.length)
                                    .toString(),
                                style: rubikMedium.copyWith(color: Colors.white, fontSize: 8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
        body: Consumer<SplashProvider>(builder: (context, config, child) {
          return Consumer<ProfileProvider>(builder: (context, profile, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isLoggedIn
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('${profile.points.toStringAsFixed(1)}',
                                          style: rubikMedium.copyWith(fontSize: 22)),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.favorite,
                                        color: Theme.of(context).primaryColor,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                  Text('Heart Balance', style: rubikMedium.copyWith(fontSize: 16)),
                                ],
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                                  minimumSize: Size(150, 30),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, Routes.getDashboardRoute('menu'));
                                },
                                child: Text('Reward Options',
                                    style: rubikRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                    )),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                width: Get.width,
                                height: 40,
                                child: CustomButton(
                                    btnTxt: 'Sign Up',
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.getLoginRoute());
                                    }),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: Get.width,
                                height: 40,
                                child: CustomButton(
                                    btnTxt: getTranslated('login', context),
                                    onTap: () {
                                      Navigator.pushNamed(context, Routes.getLoginRoute());
                                    }),
                              ),
                            ],
                          ),
                    ProgressTimeline(points),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Let\'s Get Started', style: rubikMedium.copyWith(fontSize: 14)),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: config.configModel.bannerForRestaurantWebApp.length,
                        itemBuilder: (context, index) {
                          var banner = config.configModel.bannerForRestaurantWebApp[index];
                          bool isRight = (banner.bannerType == 'catering' ||
                                  banner.bannerType == 'product' ||
                                  banner.bannerType == 'simple') &&
                              banner.isMobileView == 0;
                          return isRight
                              ? HomeBannerCard(
                                  bannerForRestaurantWebApp: banner,
                                  imageBaseUrl: config.baseUrls.bannerImageUrl,
                                )
                              : SizedBox();
                        })
                  ],
                ),
              ),
            );
          });
        }));
  }
}

class HomeBannerCard extends StatefulWidget {
  BannerForRestaurantWebApp bannerForRestaurantWebApp;
  String imageBaseUrl;

  HomeBannerCard({Key key, this.bannerForRestaurantWebApp, this.imageBaseUrl}) : super(key: key);

  @override
  State<HomeBannerCard> createState() => _HomeBannerCardState();
}

class _HomeBannerCardState extends State<HomeBannerCard> {
  @override
  Widget build(BuildContext context) {
    print('${widget.imageBaseUrl}/${widget.bannerForRestaurantWebApp.image[0]}');
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FadeInImage.assetNetwork(
              placeholder: Images.placeholder_rectangle,
              fit: BoxFit.cover,
              height: 150,
              width: Get.width,
              image: '${widget.imageBaseUrl}/${widget.bannerForRestaurantWebApp.image[0]}',
              imageErrorBuilder: (c, o, s) =>
                  Image.asset(Images.placeholder_rectangle, fit: BoxFit.cover, height: 150, width: Get.width),
            ),
          ),
          if (widget.bannerForRestaurantWebApp.bannerType != 'catering') ...[
            SizedBox(
              height: 10,
            ),
            Text('${widget.bannerForRestaurantWebApp.title}', style: rubikMedium.copyWith(fontSize: 16))
                .marginSymmetric(horizontal: 6),
            SizedBox(
              height: 10,
            ),
            Text(
              '${widget.bannerForRestaurantWebApp.description ?? ''}',
              style: rubikRegular.copyWith(
                fontSize: 14,
              ),
              maxLines: 2,
            ).marginSymmetric(horizontal: 6),
          ],
          SizedBox(
            height: 10,
          ),
          widget.bannerForRestaurantWebApp.buttonText != null
              ? TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                    minimumSize: Size(150, 30),
                  ),
                  onPressed: () {
                    print('===moving1');

                    if (widget.bannerForRestaurantWebApp.buttonText == 'Order Now') {
                      print('===moving');
                      Navigator.pushReplacementNamed(context, Routes.getDashboardRoute('food_menu'));
                    } else {
                      Navigator.pushNamed(context, Routes.getSupportRoute());
                    }
                  },
                  child: Text(widget.bannerForRestaurantWebApp.buttonText ?? '',
                      style: rubikRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                      )),
                ).marginSymmetric(horizontal: 4)
              : SizedBox.shrink(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
