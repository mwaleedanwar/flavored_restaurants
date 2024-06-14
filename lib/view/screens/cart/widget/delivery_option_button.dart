import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:provider/provider.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String title;
  final bool kmWiseFee;
  DeliveryOptionButton({@required this.value, @required this.title, @required this.kmWiseFee});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setOrderType(value, notify: true),
          child: Row(
            children: [
              Radio(
                value: value,
                groupValue: order.orderType,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (String value) => order.setOrderType(value),
              ),
              SizedBox(width: 5),

              Text(title, style: rubikRegular),
              // SizedBox(width: 5),
              //
              // kmWiseFee ? SizedBox() : Text('(${value == 'delivery' ? PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false)
              //     .configModel.deliveryCharge) : getTranslated('free', context)})', style: rubikMedium),
            ],
          ),
        );
      },
    );
  }
}
