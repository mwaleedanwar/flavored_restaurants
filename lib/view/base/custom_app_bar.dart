import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? bgColor;
  final bool isBackButtonExist;
  final void Function()? onBackPressed;
  final BuildContext context;
  const CustomAppBar({
    super.key,
    required this.title,
    this.isBackButtonExist = true,
    this.onBackPressed,
    required this.context,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: rubikMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).textTheme.bodyLarge?.color)),
      centerTitle: true,
      leading: isBackButtonExist
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyLarge?.color,
              onPressed: () => onBackPressed ?? Navigator.pop(context),
            )
          : const SizedBox(),
      backgroundColor: bgColor ?? Theme.of(context).cardColor,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, ResponsiveHelper.isDesktop(context) ? 80 : 40);
}
