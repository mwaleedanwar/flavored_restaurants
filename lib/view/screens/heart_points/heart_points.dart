import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/heart_points/widgets/progress_with_dots.dart';

import '../../../helper/product_type.dart';
import '../../../helper/responsive_helper.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/product_provider.dart';
import '../../../provider/profile_provider.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/not_logged_in_screen.dart';
import '../../base/web_app_bar.dart';
import '../home/widget/product_view.dart';

class HeartPointScreen extends StatefulWidget {
  const HeartPointScreen({super.key});

  @override
  State<HeartPointScreen> createState() => _HeartPointScreenState();
}

class _HeartPointScreenState extends State<HeartPointScreen> {
  late bool _isLoggedIn;
  double points = 0.0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).getLoyaltyProductList(context);
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context).then((value) {
        if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel?.point != null) {
          points = Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.point!.toDouble();
        }
      });
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
            : CustomAppBar(context: context, title: 'Reward Points', isBackButtonExist: false),
        body: loading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Consumer<ProductProvider>(builder: (context, cartProvider, child) {
                return Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: SingleChildScrollView(
                    child: _isLoggedIn
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null
                                  ? Column(
                                      children: [
                                        Center(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                            '${Provider.of<ProfileProvider>(context, listen: false).userInfoModel?.point ?? 0.0}',
                                                            style: rubikMedium.copyWith(fontSize: 50)),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Icon(
                                                          Icons.favorite,
                                                          color: Theme.of(context).primaryColor,
                                                        )
                                                      ],
                                                    )
                                                  : Center(
                                                      child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                                    )),
                                              Text('Hearts balance',
                                                  style:
                                                      rubikMedium.copyWith(fontSize: 20, fontWeight: FontWeight.w400)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ProgressTimeline(points),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          'Rewards you can get with hearts',
                                          style: rubikMedium.copyWith(fontSize: 20),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                    )).marginOnly(bottom: 20),
                              const ProductView(
                                productType: ProductType.LOYALTY_PRODUCT,
                                isFromPointsScreen: true,
                              ),
                            ],
                          )
                        : const NotLoggedInScreen(),
                  ),
                );
              }));
  }
}
