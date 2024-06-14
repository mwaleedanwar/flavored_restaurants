import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/app_localization.dart';

String getTranslated(String key, BuildContext context) {
  return AppLocalization.of(context).translate(key);
}
