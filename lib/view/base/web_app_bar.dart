import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/category_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/language_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/category_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/language_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/localization_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/search_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_text_field.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/on_hover.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/web/widget/cetegory_hover_widget.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/web/widget/languageHover_widget.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/web/widget/status_widget.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:provider/provider.dart';

import '../../helper/salutations_function.dart';
import '../../provider/profile_provider.dart';
import '../../provider/theme_provider.dart';
import '../screens/heart_points/heart_points.dart';
import '../screens/menu/menu_screen.dart';
import '../screens/refer_and_earn/refer_and_earn_screen.dart';
import 'branch_button_view.dart';

class WebAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  State<WebAppBar> createState() => _WebAppBarState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _WebAppBarState extends State<WebAppBar> {
  List<PopupMenuEntry<Object>> popUpMenuList(BuildContext context) {
    List<PopupMenuEntry<Object>> list = <PopupMenuEntry<Object>>[];
    List<CategoryModel> _categoryList = Provider.of<CategoryProvider>(context, listen: false).categoryList;
    list.add(PopupMenuItem(
      padding: EdgeInsets.zero,
      value: _categoryList,
      child: MouseRegion(
        onExit: (_) => Navigator.of(context).pop(),
        child: CategoryHoverWidget(categoryList: _categoryList),
      ),
    ));
    return list;
  }

  List<PopupMenuEntry<Object>> popUpLanguageList(BuildContext context) {
    List<PopupMenuEntry<Object>> _languagePopupMenuEntryList = <PopupMenuEntry<Object>>[];
    List<LanguageModel> _languageList = AppConstants.languages;
    _languagePopupMenuEntryList.add(PopupMenuItem(
      padding: EdgeInsets.zero,
      value: _languageList,
      child: MouseRegion(
        onExit: (_) => Navigator.of(context).pop(),
        child: LanguageHoverWidget(languageList: _languageList),
      ),
    ));
    return _languagePopupMenuEntryList;
  }

  _showPopupMenu(Offset offset, BuildContext context, bool isCategory) async {
    double left = offset.dx;
    double top = offset.dy;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, overlay.size.width, overlay.size.height),
      items: isCategory ? popUpMenuList(context) : popUpLanguageList(context),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    Provider.of<LanguageProvider>(context, listen: false).initializeAllLanguages(context);
    final LanguageModel _currentLanguage = AppConstants.languages.firstWhere((language) =>
        language.languageCode == Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
        BoxShadow(
            color: ColorResources.getWhiteAndBlack(context).withOpacity(0.10), blurRadius: 20, offset: Offset(0, 10))
      ]),
      child: Column(
        children: [
          Consumer<ProfileProvider>(builder: (context, profile, child) {
            return Container(
              color: F.appbarHeaderColor,
              child: Center(
                child: SizedBox(
                  width: 1170,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _isLoggedIn && profile.userInfoModel != null
                            ? Row(
                                children: [
                                  Text('${getGreetingMessage()}, ${profile.userInfoModel.fName}',
                                      style: poppinsRegular.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                          color: ColorResources.COLOR_WHITE)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    getGreetingIcons(),
                                    height: 15,
                                  ),
                                ],
                              )
                            : SizedBox(),
                        !Provider.of<SplashProvider>(context, listen: false).isRestaurantOpenNow(context)
                            ? Consumer<OrderProvider>(builder: (context, orderProvider, child) {
                                return Text(
                                  '${'${getTranslated('restaurant_is_close_now', context)}'}',
                                  style:
                                      rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.white),
                                );
                              })
                            : SizedBox(),
                        !_isLoggedIn
                            ? InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, Routes.getSignUpRoute());
                                },
                                child: Text(
                                  'Join ${F.appName} Rewards, win \$500! Be entered in a drawing to win on ${DateTime.now().month + 1}/1',
                                  style:
                                      rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.white),
                                ),
                              )
                            : SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BranchButtonView(isRow: true),
                            SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                              child: Text(getTranslated('dark_theme', context),
                                  style: poppinsRegular.copyWith(
                                      color: ColorResources.COLOR_WHITE, fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
                            ),
                            StatusWidget(),
                            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                            InkWell(
                              onTap: () {
                                if (_isLoggedIn) {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => SignOutConfirmationDialog());
                                } else {
                                  Navigator.pushNamed(context, Routes.getLoginRoute());
                                }
                              },
                              child: OnHover(builder: (isHover) {
                                return Row(
                                  children: [
                                    Icon(Icons.lock_outlined,
                                        color: ColorResources.COLOR_WHITE, size: Dimensions.PADDING_SIZE_DEFAULT),
                                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                    Text(getTranslated(_isLoggedIn ? 'logout' : 'login', context),
                                        style: poppinsRegular.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                            color: ColorResources.COLOR_WHITE))
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          Expanded(
            child: Center(
              child: SizedBox(
                  width: 1170,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<ProductProvider>(context, listen: false).latestOffset = 1;
                          Navigator.pushNamed(context, Routes.getMainRoute());
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Provider.of<SplashProvider>(context).baseUrls != null
                                  ? Consumer<SplashProvider>(
                                      builder: (context, splash, child) => FadeInImage.assetNetwork(
                                            placeholder: Images.placeholder_rectangle,
                                            image:
                                                '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}',
                                            width: 120,
                                            height: 80,
                                            imageErrorBuilder: (c, o, s) => Image.asset(F.logo, width: 120, height: 80),
                                          ))
                                  : SizedBox(),
                            ),
                          ],
                        ),
                      ),
                      OnHover(builder: (isHover) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.getHomeRoute(fromAppBar: 'true'));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                            child: Text(getTranslated('home', context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: rubikRegular.copyWith(
                                    color: isHover
                                        ? Theme.of(context).primaryColor
                                        : ColorResources.getWhiteAndBlack(context),
                                    fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ),
                        );
                      }),

                      OnHover(
                        builder: (isHover) {
                          return InkWell(
                              onTap: () {
                                if (_isLoggedIn) {
                                  Navigator.pushNamed(context, Routes.getDashboardRoute('order'));
                                } else {
                                  Navigator.pushNamed(context, Routes.getLoginRoute());
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                child: Text('Orders',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: rubikRegular.copyWith(
                                        color: isHover
                                            ? Theme.of(context).primaryColor
                                            : ColorResources.getWhiteAndBlack(context),
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ));
                        },
                      ),
                      OnHover(
                        builder: (isHover) {
                          return InkWell(
                              onTap: () {
                                if (_isLoggedIn) {
                                  Navigator.pushNamed(context, Routes.getDashboardRoute('favourite'));
                                } else {
                                  Navigator.pushNamed(context, Routes.getLoginRoute());
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                child: Text('Favourites',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: rubikRegular.copyWith(
                                        color: isHover
                                            ? Theme.of(context).primaryColor
                                            : ColorResources.getWhiteAndBlack(context),
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ));
                        },
                      ),
                      OnHover(
                        builder: (isHover) {
                          return InkWell(
                              onTap: () {
                                if (_isLoggedIn) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => HeartPointScreen()));
                                } else {
                                  Navigator.pushNamed(context, Routes.getLoginRoute());
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                child: Text('Rewards',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: rubikRegular.copyWith(
                                        color: isHover
                                            ? Theme.of(context).primaryColor
                                            : ColorResources.getWhiteAndBlack(context),
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ));
                        },
                      ),

                      OnHover(
                        builder: (isHover) {
                          return InkWell(
                              onTap: () {
                                if (_isLoggedIn) {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => ReferAndEarnScreen()));
                                } else {
                                  Navigator.pushNamed(context, Routes.getLoginRoute());
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                child: Text('Refer & Earn',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: rubikRegular.copyWith(
                                        color: isHover
                                            ? Theme.of(context).primaryColor
                                            : ColorResources.getWhiteAndBlack(context),
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ));
                        },
                      ),
                      Spacer(),
                      // Container(
                      //   width: 450,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(2.0),
                      //   ),
                      //   child: Consumer<SearchProvider>(
                      //     builder: (context,search,_) {
                      //
                      //       return Padding(
                      //         padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                      //         child: CustomTextField(
                      //           hintText: getTranslated('search_items_here', context),
                      //           isShowBorder: true,
                      //           fillColor: Theme.of(context).canvasColor,
                      //           isShowSuffixIcon: true,
                      //           suffixIconUrl: search.searchController.text.length > 0? Images.close : Images.search,
                      //           onChanged: (str){
                      //             str.length = 0;
                      //             search.getSearchText(str);
                      //             // print('===>${search.searchController.text.toString()}');
                      //
                      //           },
                      //
                      //           onSuffixTap: () {
                      //               // if (search.searchController.text.length > 0) {
                      //               //   search.searchController.clear();
                      //               //   search.getSearchText('');
                      //               // }
                      //             if(search.searchController.text.length > 0 && search.isSearch == true){
                      //               // Provider.of<SearchProvider>(context,listen: false).saveSearchAddress(search.searchController.text);
                      //               // Provider.of<SearchProvider>(context,listen: false).searchProduct(search.searchController.text, context);
                      //               Navigator.pushNamed(context, Routes.getSearchResultRoute(search.searchController.text),
                      //                  // arguments: SearchResultScreen(searchString: search.searchController.text),
                      //               );
                      //
                      //               search.searchDone();
                      //
                      //             }
                      //             else if (search.searchController.text.length > 0 && search.isSearch == false) {
                      //               search.searchController.clear();
                      //               search.getSearchText('');
                      //
                      //               search.searchDone();
                      //             }
                      //           },
                      //           controller: search.searchController,
                      //           inputAction: TextInputAction.search,
                      //           isIcon: true,
                      //           onSubmit: (text) {
                      //               if (search.searchController.text.length > 0) {
                      //                 // Provider.of<SearchProvider>(context,listen: false).saveSearchAddress(search.searchController.text);
                      //                 // Provider.of<SearchProvider>(context,listen: false).searchProduct(search.searchController.text, context);
                      //                 Navigator.pushNamed(context, Routes.getSearchResultRoute(search.searchController.text));
                      //                 //Navigator.pushNamed(context, Routes.getSearchResultRoute(_searchController.text.replaceAll(' ', '-')));
                      //
                      //                 search.searchDone();
                      //               }
                      //
                      //           },),
                      //       );
                      //
                      //     }
                      //   ),
                      // ),

                      InkWell(
                          onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
                          child: OnHover(builder: (isHover) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                              child: Stack(clipBehavior: Clip.none, children: [
                                Icon(Icons.shopping_cart,
                                    size: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                                    color: isHover
                                        ? Theme.of(context).primaryColor
                                        : ColorResources.getWhiteAndBlack(context)),
                                Positioned(
                                  top: -7,
                                  right: -7,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: F.appbarHeaderColor),
                                    child: Center(
                                      child: Text(
                                        (Provider.of<CartProvider>(context).cartList.length +
                                                Provider.of<CartProvider>(context).cateringList.length +
                                                Provider.of<CartProvider>(context).happyHoursList.length +
                                                Provider.of<CartProvider>(context).dealsList.length)
                                            .toString(),
                                        style: rubikMedium.copyWith(color: ColorResources.COLOR_WHITE, fontSize: 8),
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                            );
                          })),
                      OnHover(builder: (isHover) {
                        return InkWell(
                          onTap: () {
                            print('-tapped');
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MenuScreen()));
                          },
                          child: Icon(Icons.menu,
                              size: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                              color:
                                  isHover ? Theme.of(context).primaryColor : ColorResources.getWhiteAndBlack(context)),
                        );
                      })
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // ignore: override_on_non_overriding_member
  Size get preferredSize => Size(double.maxFinite, 50);
}
