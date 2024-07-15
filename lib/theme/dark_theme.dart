// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';

final baseDarkTheme = ThemeData(
  fontFamily: 'Rubik',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF2C2C2C),
  cardColor: const Color(0xFF252525),
  hintColor: const Color(0xFFE7F6F8),
  focusColor: const Color(0xFFADC4C8),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
    foregroundColor: Colors.white,
    textStyle: const TextStyle(color: Colors.white),
  )),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  textTheme: const TextTheme(
    labelLarge: TextStyle(color: Color(0xFF252525)),
    displayLarge: TextStyle(fontWeight: FontWeight.w300, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    displayMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    displaySmall: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    headlineMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    headlineSmall: TextStyle(fontWeight: FontWeight.w700, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    titleLarge: TextStyle(fontWeight: FontWeight.w800, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    bodySmall: TextStyle(fontWeight: FontWeight.w900, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    titleMedium: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 12.0),
    bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
  ),
);

final dark_nopal_dos = baseDarkTheme.copyWith(primaryColor: const Color(0xFF697b18));

final dark_maa_kitchen = baseDarkTheme.copyWith(primaryColor: const Color(0xFFBF1E2E));

final dark_cafe_santorini = baseDarkTheme.copyWith(primaryColor: const Color(0xFF8B288C));

final dark_halal_china_box = baseDarkTheme.copyWith(primaryColor: const Color(0xFFa60f0f));

final dark_apnaa_bazaar = baseDarkTheme.copyWith(primaryColor: const Color(0xFFC42127));

final dark_willy_b_steak_house = baseDarkTheme.copyWith(primaryColor: const Color(0xFF8b0211));

final dark_chaat_house = baseDarkTheme.copyWith(primaryColor: const Color(0xFFF9333E));

final dark_kabsah_theme = baseDarkTheme.copyWith(primaryColor: const Color(0xFFDD9933));

final dark_5th_element = baseDarkTheme.copyWith(primaryColor: const Color(0xFFf88218));

final dark_alladin_grill = baseDarkTheme.copyWith(primaryColor: const Color(0xFF950103));

final dark_jax_spice = baseDarkTheme.copyWith(primaryColor: const Color(0xFFf8ac6a));

final dark_af_grills = baseDarkTheme.copyWith(primaryColor: const Color(0xFFED6067));
