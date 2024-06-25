import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';

final baseLightTheme = ThemeData(
  fontFamily: 'Rubik',
  brightness: Brightness.light,
  cardColor: Colors.white,
  focusColor: const Color(0xFFADC4C8),
  hintColor: const Color(0xFF52575C),
  backgroundColor: const Color(0xFFFFFFFF),
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
    button: TextStyle(color: Colors.white),
    headline1: TextStyle(fontWeight: FontWeight.w300, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    headline2: TextStyle(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    headline3: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    headline4: TextStyle(fontWeight: FontWeight.w600, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    headline5: TextStyle(fontWeight: FontWeight.w700, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    headline6: TextStyle(fontWeight: FontWeight.w800, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    caption: TextStyle(fontWeight: FontWeight.w900, fontSize: Dimensions.FONT_SIZE_DEFAULT),
    subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
    bodyText2: TextStyle(fontSize: 12.0),
    bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
  ),
);

final light_nopal_dos = baseLightTheme.copyWith(primaryColor: const Color(0xFF697b18));

final light_maa_kitchen = baseLightTheme.copyWith(primaryColor: const Color(0xFFBF1E2E));

final light_cafe_santorini = baseLightTheme.copyWith(primaryColor: const Color(0xFF8B288C));

final light_halal_china_box = baseLightTheme.copyWith(primaryColor: const Color(0xFFa60f0f));

final light_apnaa_bazaar = baseLightTheme.copyWith(primaryColor: const Color(0xFFC42127));

final light_willy_b_steak_house = baseLightTheme.copyWith(primaryColor: const Color(0xFF8b0211));

final light_chaat_house = baseLightTheme.copyWith(primaryColor: const Color(0xFFF9333E));
