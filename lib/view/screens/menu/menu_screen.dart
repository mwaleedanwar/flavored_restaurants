import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/profile_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/menu/widget/options_view.dart';

import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

bool _isLoggedIn = false;

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
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
          preferredSize: Size(MediaQuery.of(context).size.width, 75),
          child: Padding(
            padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT, top: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_sharp,
                      size: 20,
                    )),
                const SizedBox(
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
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                alignment: Alignment.centerLeft,
                child: _isLoggedIn
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          _isLoggedIn
                              ? profileProvider.userInfoModel != null
                                  ? Text(
                                      profileProvider.userInfoModel!.fName ?? '',
                                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                    )
                                  : Container(height: 15, width: 100, color: Colors.white)
                              : const SizedBox(),
                          const SizedBox(
                            height: 5,
                          ),
                          _isLoggedIn
                              ? profileProvider.userInfoModel != null
                                  ? Text(
                                      profileProvider.userInfoModel!.email ?? '',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.grey),
                                    )
                                  : Container(height: 15, width: 100, color: Colors.white)
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    : const SizedBox.shrink()),
            const Expanded(child: OptionsView()),
          ]),
        ));
  }
}
