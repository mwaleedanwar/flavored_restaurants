import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';

class CustomStepper extends StatelessWidget {
  final bool isActive;
  final bool haveTopBar;
  final String title;
  final Widget? child;
  final double height;
  const CustomStepper({
    super.key,
    required this.title,
    required this.isActive,
    this.child,
    this.haveTopBar = true,
    this.height = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      haveTopBar
          ? Row(children: [
              Container(
                height: height,
                width: 2,
                margin: const EdgeInsets.only(left: 14),
                color: isActive ? Theme.of(context).primaryColor : ColorResources.COLOR_GREY,
              ),
              child == null ? const SizedBox() : child!,
            ])
          : const SizedBox(),
      Row(children: [
        isActive
            ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 30)
            : Container(
                padding: const EdgeInsets.all(7),
                margin: const EdgeInsets.only(left: 6),
                decoration: BoxDecoration(
                    border: Border.all(color: ColorResources.COLOR_GREY, width: 2), shape: BoxShape.circle),
              ),
        SizedBox(width: isActive ? Dimensions.PADDING_SIZE_EXTRA_SMALL : Dimensions.PADDING_SIZE_SMALL),
        Text(title,
            style: isActive
                ? rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)
                : rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      ]),
    ]);
  }
}
