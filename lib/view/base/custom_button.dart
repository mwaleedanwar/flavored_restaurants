import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String btnTxt;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final double borderRadius;
  const CustomButton({
    super.key,
    this.onTap,
    this.btnTxt = '',
    this.backgroundColor,
    this.textStyle,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onTap == null
          ? ColorResources.getGreyColor(context)
          : backgroundColor ?? Theme.of(context).primaryColor,
      minimumSize: Size(MediaQuery.of(context).size.width, 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
    return TextButton(
      onPressed: onTap,
      style: flatButtonStyle,
      child: Text(
        btnTxt,
        style: textStyle ??
            Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: ColorResources.COLOR_WHITE,
                  fontSize: Dimensions.FONT_SIZE_LARGE,
                ),
      ),
    );
  }
}
