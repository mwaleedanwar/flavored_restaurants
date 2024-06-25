import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';

final baseDarkTheme = ThemeData(
  fontFamily: 'Rubik',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF2C2C2C),
  cardColor: const Color(0xFF252525),
  backgroundColor: const Color(0xFF343636),
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
    button: TextStyle(color: Color(0xFF252525)),
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

final dark_nopal_dos = baseDarkTheme.copyWith(primaryColor: const Color(0xFF697b18));

final dark_maa_kitchen = baseDarkTheme.copyWith(primaryColor: const Color(0xFFBF1E2E));

final dark_cafe_santorini = baseDarkTheme.copyWith(primaryColor: const Color(0xFF8B288C));

final dark_halal_china_box = baseDarkTheme.copyWith(primaryColor: const Color(0xFFa60f0f));

final dark_apnaa_bazaar = baseDarkTheme.copyWith(primaryColor: const Color(0xFFC42127));

final dark_willy_b_steak_house = baseDarkTheme.copyWith(primaryColor: const Color(0xFF8b0211));

final dark_chaat_house = baseDarkTheme.copyWith(primaryColor: const Color(0xFFF9333E));

final dark_kabsah_theme = baseDarkTheme.copyWith(primaryColor: const Color(0xFFDD9933));
