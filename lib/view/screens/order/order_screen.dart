import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/not_logged_in_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/order/widget/order_view.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with TickerProviderStateMixin {
  TabController _tabController;
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
      Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100))
          : CustomAppBar(
              context: context,
              title: getTranslated('my_order', context),
              isBackButtonExist: !ResponsiveHelper.isMobile(context)),
      body: _isLoggedIn
          ? Consumer<OrderProvider>(
              builder: (context, order, child) {
                return Column(children: [
                  Center(
                    child: Container(
                      width: 1170,
                      color: Theme.of(context).cardColor,
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Theme.of(context).textTheme.bodyText1.color,
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorWeight: 3,
                        unselectedLabelStyle: rubikRegular.copyWith(
                            color: ColorResources.COLOR_HINT, fontSize: Dimensions.FONT_SIZE_SMALL),
                        labelStyle: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                        tabs: [
                          Tab(text: getTranslated('running', context)),
                          Tab(text: getTranslated('history', context)),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                    controller: _tabController,
                    children: [
                      OrderView(isRunning: true),
                      OrderView(isRunning: false),
                    ],
                  )),
                ]);
              },
            )
          : NotLoggedInScreen(),
    );
  }
}
