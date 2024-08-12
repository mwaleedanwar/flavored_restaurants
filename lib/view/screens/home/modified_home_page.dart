import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/profile_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/config_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/salutations_function.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/heart_points/widgets/progress_with_dots.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/menu/menu_screen.dart';

class ModifiedHomePage extends StatefulWidget {
  final VoidCallback? navigateToMenu;
  final VoidCallback? navigateToReward;
  const ModifiedHomePage({super.key, this.navigateToMenu, this.navigateToReward});

  @override
  State<ModifiedHomePage> createState() => _ModifiedHomePageState();
}

class _ModifiedHomePageState extends State<ModifiedHomePage> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  bool _isLoggedIn = false;
  double points = 0;

  Future<void> _loadData(BuildContext context) async {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      _isLoggedIn = true;

      if (_isLoggedIn) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context).then((value) {
          if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel?.point != null) {
            points = Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.point!.toDouble();
            setState(() {});
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Theme.of(context).cardColor,
          title: Consumer<SplashProvider>(
              builder: (context, splash, child) => Consumer<ProfileProvider>(builder: (context, profile, child) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(F.logo, width: 40, height: 40),
                        const SizedBox(width: 10),
                        _isLoggedIn && profile.userInfoModel != null
                            ? Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      '${getGreetingMessage()}, ${Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.fName ?? ''}',
                                      style: rubikBold.copyWith(color: Theme.of(context).primaryColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      getGreetingIcons(),
                                      height: 25,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    );
                  })),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuScreen())),
              icon: Icon(Icons.menu, color: Theme.of(context).textTheme.displayLarge?.color),
            ),
          ],
        ),
        body: Consumer2<SplashProvider, ProfileProvider>(builder: (context, config, profile, child) {
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
                                    Text(profile.points.toStringAsFixed(1), style: rubikMedium.copyWith(fontSize: 22)),
                                    const SizedBox(
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
                                minimumSize: const Size(150, 30),
                              ),
                              onPressed: widget.navigateToReward ?? () {},
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
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              child: CustomButton(
                                  btnTxt: 'Sign Up',
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.getCreateAccountRoute());
                                  }),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Let\'s Get Started', style: rubikMedium.copyWith(fontSize: 14)),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: config.configModel?.bannerForRestaurantWebApp?.length,
                      itemBuilder: (context, index) {
                        var banner = config.configModel!.bannerForRestaurantWebApp![index];
                        bool isRight = (banner.bannerType == 'catering' ||
                                banner.bannerType == 'product' ||
                                banner.bannerType == 'simple') &&
                            banner.isMobileView == 0;
                        return isRight
                            ? HomeBannerCard(
                                bannerForRestaurantWebApp: banner,
                                imageBaseUrl: config.baseUrls!.bannerImageUrl,
                          navigateToMenu: widget.navigateToMenu,
                              )
                            : const SizedBox();
                      })
                ],
              ),
            ),
          );
        }));
  }
}

class HomeBannerCard extends StatefulWidget {
  final BannerForRestaurantWebApp bannerForRestaurantWebApp;
  final String imageBaseUrl;
  final VoidCallback? navigateToMenu;

  const HomeBannerCard(
      {super.key, required this.bannerForRestaurantWebApp, required this.imageBaseUrl, this.navigateToMenu});

  @override
  State<HomeBannerCard> createState() => _HomeBannerCardState();
}

class _HomeBannerCardState extends State<HomeBannerCard> {
  @override
  Widget build(BuildContext context) {
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
              width: MediaQuery.of(context).size.width,
              image: '${widget.imageBaseUrl}/${widget.bannerForRestaurantWebApp.image[0]}',
              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_rectangle,
                  fit: BoxFit.cover, height: 150, width: MediaQuery.of(context).size.width),
            ),
          ),
          if (widget.bannerForRestaurantWebApp.bannerType != 'catering') ...[
            const SizedBox(
              height: 10,
            ),
            Text(widget.bannerForRestaurantWebApp.title, style: rubikMedium.copyWith(fontSize: 16))
                .marginSymmetric(horizontal: 6),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.bannerForRestaurantWebApp.description ?? '',
              style: rubikRegular.copyWith(
                fontSize: 14,
              ),
              maxLines: 2,
            ).marginSymmetric(horizontal: 6),
          ],
          const SizedBox(
            height: 10,
          ),
          widget.bannerForRestaurantWebApp.buttonText != null
              ? TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                    ),
                    minimumSize: const Size(150, 30),
                  ),
                  onPressed: () async {
                    if (widget.bannerForRestaurantWebApp.buttonText == 'Order Now') {
                      if (widget.navigateToMenu != null) {
                        widget.navigateToMenu!();
                      }
                    } else {
                      await Navigator.pushNamed(context, Routes.getSupportRoute());
                    }
                  },
                  child: Text(widget.bannerForRestaurantWebApp.buttonText ?? '',
                      style: rubikRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                      )),
                ).marginSymmetric(horizontal: 4)
              : const SizedBox.shrink(),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
