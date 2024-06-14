import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100))
          : null,
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: SizedBox(
              width: 1170,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(30),
                    child: ResponsiveHelper.isWeb()
                        ? Consumer<SplashProvider>(
                            builder: (context, splash, child) => FadeInImage.assetNetwork(
                              placeholder: Images.placeholder_rectangle,
                              image: splash.baseUrls != null
                                  ? '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}'
                                  : '',
                              height: 200,
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_rectangle, height: 200),
                            ),
                          )
                        : Image.asset(F.logo, height: 200),
                  ),
                  SizedBox(height: 30),
                  Text(
                    getTranslated('welcome', context),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(color: Theme.of(context).textTheme.bodyText1.color, fontSize: 32),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    child: Text(
                      getTranslated('welcome_to_efood', context),
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getGreyColor(context)),
                    ),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    child: CustomButton(
                      btnTxt: getTranslated('login', context),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, Routes.getLoginRoute());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: Dimensions.PADDING_SIZE_DEFAULT,
                        right: Dimensions.PADDING_SIZE_DEFAULT,
                        bottom: Dimensions.PADDING_SIZE_DEFAULT,
                        top: 12),
                    child: CustomButton(
                      btnTxt: getTranslated('signup', context),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, Routes.getCreateAccountRoute());
                      },
                      backgroundColor: Colors.black,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size(1, 40),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, Routes.getMainRoute());
                    },
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: '${getTranslated('login_as_a', context)} ',
                          style: rubikRegular.copyWith(color: ColorResources.getGreyColor(context))),
                      TextSpan(
                          text: getTranslated('guest', context),
                          style: rubikMedium.copyWith(color: Theme.of(context).textTheme.bodyText1.color)),
                    ])),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
