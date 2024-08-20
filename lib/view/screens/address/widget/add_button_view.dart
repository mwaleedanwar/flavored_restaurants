import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/on_hover.dart';

class AddButtonView extends StatelessWidget {
  final void Function() onTap;
  const AddButtonView({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: OnHover(builder: (onHover) {
        return InkWell(
          onTap: onTap,
          hoverColor: Colors.transparent,
          child: Container(
            width: 110.0,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(30.0)),
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Row(
              children: [
                const Icon(Icons.add_circle, color: Colors.white),
                const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Text(getTranslated('add_new', context), style: rubikRegular.copyWith(color: Colors.white))
              ],
            ),
          ),
        );
      }),
    );
  }
}
