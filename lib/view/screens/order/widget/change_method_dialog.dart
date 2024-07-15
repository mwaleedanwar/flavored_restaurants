// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:provider/provider.dart';

class ChangeMethodDialog extends StatelessWidget {
  final String orderID;
  final Function callback;
  const ChangeMethodDialog({super.key, required this.orderID, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Image.asset(Images.wallet, color: Theme.of(context).primaryColor, width: 100, height: 100),
                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                Text(
                  getTranslated('do_you_want_to_switch', context),
                  textAlign: TextAlign.justify,
                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                !order.isLoading
                    ? Row(children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: const Size(1, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                            ),
                            child: Text(getTranslated('no', context)),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Expanded(
                            child: CustomButton(
                                btnTxt: getTranslated('yes', context),
                                onTap: () async {
                                  await order.updatePaymentMethod(orderID, callback);
                                  Navigator.pop(context);
                                })),
                      ])
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
              ]),
            ),
          ),
        );
      },
    );
  }
}
