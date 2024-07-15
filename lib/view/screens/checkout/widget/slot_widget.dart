import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:provider/provider.dart';

class SlotWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final void Function() onTap;
  const SlotWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color:
                    Provider.of<ThemeProvider>(context, listen: false).darkTheme
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
                spreadRadius: 0.5,
                blurRadius: 0.5,
              )
            ],
          ),
          child: Text(
            title,
            style: rubikRegular.copyWith(
                color: isSelected
                    ? Theme.of(context).cardColor
                    : Theme.of(context).textTheme.displayLarge?.color),
          ),
        ),
      ),
    );
  }
}
