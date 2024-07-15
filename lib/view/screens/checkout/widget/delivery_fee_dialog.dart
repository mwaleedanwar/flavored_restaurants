import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_divider.dart';
import 'package:provider/provider.dart';

class DeliveryFeeDialog extends StatelessWidget {
  final double amount;
  final double distance;
  const DeliveryFeeDialog({
    super.key,
    required this.amount,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    double deliveryCharge = distance *
        (Provider.of<SplashProvider>(context, listen: false)
                .configModel
                ?.deliveryManagement
                ?.shippingPerKm ??
            1);
    final minShippingCharge =
        Provider.of<SplashProvider>(context, listen: false)
            .configModel
            ?.deliveryManagement
            ?.minShippingCharge;
    if (minShippingCharge != null && deliveryCharge < minShippingCharge) {
      deliveryCharge = Provider.of<SplashProvider>(context, listen: false)
          .configModel!
          .deliveryManagement!
          .minShippingCharge;
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.isDesktop(context) ? 300 : 0),
      child: Consumer<OrderProvider>(builder: (context, order, child) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delivery_dining,
                  color: Theme.of(context).primaryColor,
                  size: 50,
                ),
              ),
              const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Column(children: [
                Text(
                  '${getTranslated('delivery_fee_from_your_selected_address_to_branch', context)}:',
                  style: rubikRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  PriceConverter.convertPrice(context, deliveryCharge),
                  style: rubikBold.copyWith(
                      fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                ),
                const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(getTranslated('subtotal', context),
                          style: rubikMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE)),
                      Text(PriceConverter.convertPrice(context, amount),
                          style: rubikMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE)),
                    ]),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslated('delivery_fee', context),
                        style: rubikRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE),
                      ),
                      Text(
                        '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                        style: rubikRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE),
                      ),
                    ]),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_SMALL),
                  child: CustomDivider(),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(getTranslated('total_amount', context),
                          style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                            color: Theme.of(context).primaryColor,
                          )),
                      Text(
                        PriceConverter.convertPrice(
                            context, amount + deliveryCharge),
                        style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                            color: Theme.of(context).primaryColor),
                      ),
                    ]),
              ]),
              const SizedBox(height: 30),
              CustomButton(
                  btnTxt: getTranslated('ok', context),
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ]),
          ),
        );
      }),
    );
  }
}
