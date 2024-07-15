import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/address_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/location_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/no_data_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/not_logged_in_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/address/widget/address_widget.dart';
import 'package:provider/provider.dart';

import 'widget/add_button_view.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (_isLoggedIn) {
      Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : CustomAppBar(context: context, title: getTranslated('address', context)),
      floatingActionButton: _isLoggedIn
          ? Padding(
              padding: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0),
              child: !ResponsiveHelper.isDesktop(context)
                  ? FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () => Navigator.pushNamed(
                          context, Routes.getAddAddressRoute('address', 'add', AddressModel(), amount: 0.0)),
                      child: const Icon(Icons.add, color: Colors.white),
                    )
                  : null,
            )
          : null,
      body: _isLoggedIn
          ? Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                return locationProvider.addressList != null
                    ? locationProvider.addressList!.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: () async {
                              await Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
                            },
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Center(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            minHeight: !ResponsiveHelper.isDesktop(context) &&
                                                    MediaQuery.of(context).size.height < 600
                                                ? MediaQuery.of(context).size.height
                                                : MediaQuery.of(context).size.height - 400),
                                        child: SizedBox(
                                          width: 1170,
                                          child: ResponsiveHelper.isDesktop(context)
                                              ? Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    AddButtonView(
                                                        onTap: () => Navigator.pushNamed(
                                                            context,
                                                            Routes.getAddAddressRoute('address', 'add', AddressModel(),
                                                                amount: 0.0))),
                                                    GridView.builder(
                                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          crossAxisSpacing: Dimensions.PADDING_SIZE_DEFAULT,
                                                          childAspectRatio: 4),
                                                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                                      itemCount: locationProvider.addressList!.length,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemBuilder: (context, index) => AddressWidget(
                                                        addressModel: locationProvider.addressList![index],
                                                        index: index,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : ListView.builder(
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                                  itemCount: locationProvider.addressList!.length,
                                                  itemBuilder: (context, index) => AddressWidget(
                                                    addressModel: locationProvider.addressList![index],
                                                    index: index,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    if (ResponsiveHelper.isDesktop(context)) const FooterView(),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    constraints: BoxConstraints(
                                        minHeight: !ResponsiveHelper.isDesktop(context) &&
                                                MediaQuery.of(context).size.height < 600
                                            ? MediaQuery.of(context).size.height
                                            : MediaQuery.of(context).size.height - 400),
                                    width: 1177,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        if (ResponsiveHelper.isDesktop(context))
                                          AddButtonView(
                                              onTap: () => Navigator.pushNamed(context,
                                                  Routes.getAddAddressRoute('address', 'add', AddressModel()))),
                                        const NoDataScreen(isFooter: false, isAddress: true),
                                      ],
                                    ),
                                  ),
                                ),
                                if (ResponsiveHelper.isDesktop(context)) const FooterView(),
                              ],
                            ),
                          )
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
              },
            )
          : const NotLoggedInScreen(),
    );
  }
}
