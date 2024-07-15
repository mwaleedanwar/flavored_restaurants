// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';

final baseLightTheme = ThemeData(
  fontFamily: 'Rubik',
  brightness: Brightness.light,
  cardColor: Colors.white,
  focusColor: const Color(0xFFADC4C8),
  hintColor: const Color(0xFF52575C),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
    foregroundColor: Colors.black,
    textStyle: const TextStyle(color: Colors.black),
  )),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  textTheme: const TextTheme(
    labelLarge: TextStyle(color: Colors.white),
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

final light_nopal_dos = baseLightTheme.copyWith(primaryColor: const Color(0xFF697b18));

final light_maa_kitchen = baseLightTheme.copyWith(primaryColor: const Color(0xFFBF1E2E));

final light_cafe_santorini = baseLightTheme.copyWith(primaryColor: const Color(0xFF8B288C));

final light_halal_china_box = baseLightTheme.copyWith(primaryColor: const Color(0xFFa60f0f));

final light_apnaa_bazaar = baseLightTheme.copyWith(primaryColor: const Color(0xFFC42127));

final light_willy_b_steak_house = baseLightTheme.copyWith(primaryColor: const Color(0xFF8b0211));

final light_chaat_house = baseLightTheme.copyWith(primaryColor: const Color(0xFFF9333E));

final light_kabsah_theme = baseLightTheme.copyWith(primaryColor: const Color(0xFFDD9933));

final light_5th_element = baseLightTheme.copyWith(primaryColor: const Color(0xFFf88218));

final light_alladin_grill = baseLightTheme.copyWith(primaryColor: const Color(0xFF950103));

final light_jax_spice = baseLightTheme.copyWith(primaryColor: const Color(0xFFf8ac6a));

final light_af_grills = baseLightTheme.copyWith(primaryColor: const Color(0xFFED6067));
