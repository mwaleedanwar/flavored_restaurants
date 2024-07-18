import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';

void showCustomSnackBar(
  String message,
  BuildContext context, {
  bool isError = true,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        margin: ResponsiveHelper.isDesktop(context)
            ? EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.7,
                bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                left: Dimensions.PADDING_SIZE_EXTRA_SMALL)
            : EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
}
