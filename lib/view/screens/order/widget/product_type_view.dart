import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';

class ProductTypeView extends StatelessWidget {
  final productType;
  const ProductTypeView({Key key, this.productType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return productType == null
        ? SizedBox()
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
              color: Theme.of(context).primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
              child: Text(
                getTranslated(
                  productType,
                  context,
                ),
                style: robotoRegular.copyWith(color: Colors.white),
              ),
            ),
          );
  }
}
