import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/profile_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/menu/web/menu_screen_web.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/menu/widget/options_view.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

import '../../base/custom_app_bar.dart';

class MenuScreen extends StatefulWidget {
  final Function onTap;
  MenuScreen({this.onTap});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

bool _isLoggedIn = false;

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(Get.width, 70),
          child: Padding(
            padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT, top: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_sharp,
                      size: 20,
                    )),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Account',
                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                )
              ],
            ),
          ),
        ),
        body: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => Column(children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                alignment: Alignment.centerLeft,
                child: _isLoggedIn
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          _isLoggedIn
                              ? profileProvider.userInfoModel != null
                                  ? Text(
                                      '${profileProvider.userInfoModel.fName ?? ''}',
                                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                    )
                                  : Container(height: 15, width: 100, color: Colors.white)
                              : SizedBox(),
                          SizedBox(
                            height: 5,
                          ),
                          _isLoggedIn
                              ? profileProvider.userInfoModel != null
                                  ? Text(
                                      '${profileProvider.userInfoModel.email ?? ''}',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.grey),
                                    )
                                  : Container(height: 15, width: 100, color: Colors.white)
                              : SizedBox(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    : SizedBox.shrink()),
            Expanded(child: OptionsView(onTap: widget.onTap)),
          ]),
        ));
  }
}
