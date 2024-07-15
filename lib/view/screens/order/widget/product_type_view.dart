import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';

class ProductTypeView extends StatelessWidget {
  final String? productType;
  const ProductTypeView({super.key, this.productType});

  @override
  Widget build(BuildContext context) {
    return productType == null
        ? const SizedBox()
        : Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
              color: Theme.of(context).primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
              child: Text(
                getTranslated(
                  productType!,
                  context,
                ),
                style: robotoRegular.copyWith(color: Colors.white),
              ),
            ),
          );
  }
}
