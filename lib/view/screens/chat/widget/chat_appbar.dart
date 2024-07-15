import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:provider/provider.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final BuildContext context;
  final OrderModel? orderModel;
  const ChatAppBar({
    super.key,
    this.isBackButtonExist = true,
    this.onBackPressed,
    required this.context,
    this.orderModel,
  });

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    return ResponsiveHelper.isDesktop(context)
        ? Center(
            child: Container(
                color: Theme.of(context).cardColor,
                width: 1170,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(context, Routes.getMainRoute()),
                        child: splashProvider.baseUrls != null
                            ? Consumer<SplashProvider>(
                                builder: (context, splash, child) => FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder_rectangle,
                                      image:
                                          '${splash.baseUrls!.restaurantImageUrl}/${splash.configModel!.restaurantLogo}',
                                      width: 120,
                                      height: 80,
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(Images.placeholder_rectangle, width: 120, height: 80),
                                    ))
                            : const SizedBox(),
                      ),
                    ),
                  ],
                )),
          )
        : AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    orderModel != null
                        ? '${orderModel!.deliveryMan?.fName} ${orderModel!.deliveryMan?.lName}'
                        : splashProvider.configModel?.restaurantName ?? F.appName,
                    style: rubikMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).textTheme.bodyLarge?.color)),
                orderModel == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                        child: CircleAvatar(
                          radius: Dimensions.PADDING_SIZE_DEFAULT,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.asset(Images.placeholder_user),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                        child: CircleAvatar(
                          radius: Dimensions.PADDING_SIZE_DEFAULT,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder_user,
                              fit: BoxFit.cover,
                              height: 40.0,
                              width: 40.0,
                              image:
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.deliveryManImageUrl}/${orderModel!.deliveryMan?.image ?? ''}',
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_user, fit: BoxFit.cover),
                            ),
                            // child: Image.asset(Images.placeholder_user), borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
              ],
            ),
            leading: isBackButtonExist
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
                  )
                : const SizedBox(),
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0,
            titleSpacing: 0,
          );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, ResponsiveHelper.isDesktop(context) ? 80 : 50);
}
