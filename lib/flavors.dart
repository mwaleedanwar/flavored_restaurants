import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/theme/dark_theme.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/theme/light_theme.dart';

enum Flavor {
  nopalDos,
  maaKitchen,
}

class F {
  static Flavor appFlavor;

  static String get name {
    switch (appFlavor) {
      case Flavor.nopalDos:
        return 'Nopal Dos';
      case Flavor.maaKitchen:
        return 'Maa Kitchen';
      default:
        return 'Nopal Dos';
    }
  }

  static String get BASE_URL {
    switch (appFlavor) {
      case Flavor.nopalDos:
        return 'https://nopaldos.cafescale.app';
      case Flavor.maaKitchen:
        return 'https://maakitchen.cafescale.app';
      default:
        return 'https://nopaldos.cafescale.app';
    }
  }

  static int get restaurantId {
    switch (appFlavor) {
      case Flavor.nopalDos:
        return 47;
      case Flavor.maaKitchen:
        return 14;
      default:
        return 47;
    }
  }

  static FirebaseOptions get options {
    switch (appFlavor) {
      case Flavor.nopalDos:
        return const FirebaseOptions(
          apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
          authDomain: "scalecafe-e41d3.firebaseapp.com",
          projectId: "scalecafe-e41d3",
          storageBucket: "scalecafe-e41d3.appspot.com",
          messagingSenderId: "321185419116",
          appId: "1:321185419116:web:fc43476afcc03630dded49",
          measurementId: "G-1TMNY6FWDK",
        );
      case Flavor.maaKitchen:
        return const FirebaseOptions(
          apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
          authDomain: "scalecafe-e41d3.firebaseapp.com",
          projectId: "scalecafe-e41d3",
          storageBucket: "scalecafe-e41d3.appspot.com",
          messagingSenderId: "321185419116",
          appId: "1:321185419116:web:fc43476afcc03630dded49",
          measurementId: "G-1TMNY6FWDK",
        );
      default:
        return const FirebaseOptions(
          apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
          authDomain: "scalecafe-e41d3.firebaseapp.com",
          projectId: "scalecafe-e41d3",
          storageBucket: "scalecafe-e41d3.appspot.com",
          messagingSenderId: "321185419116",
          appId: "1:321185419116:web:fc43476afcc03630dded49",
          measurementId: "G-1TMNY6FWDK",
        );
    }
  }

  static ThemeData get themeLight {
    switch (appFlavor) {
      case Flavor.nopalDos:
        return light_nopal_dos;
      case Flavor.maaKitchen:
        return light_maa_kitchen;
      default:
        return light_nopal_dos;
    }
  }

  static ThemeData get themeDark {
    switch (appFlavor) {
      case Flavor.nopalDos:
        return dark_nopal_dos;
      case Flavor.maaKitchen:
        return dark_maa_kitchen;
      default:
        return dark_nopal_dos;
    }
  }

  static Color get appbarHeaderColor {
    switch (appFlavor) {
      case Flavor.nopalDos:
        return const Color(0xFF697b18);
      case Flavor.maaKitchen:
        return const Color(0xFFBF1E2E);
      default:
        return const Color(0xFF697b18);
    }
  }

  static String get appName {
    switch (appFlavor) {
      case Flavor.nopalDos:
        return 'Nopal Dos';
      case Flavor.maaKitchen:
        return 'Maa Kitchen';
      default:
        return 'Nopal Dos';
    }
  }

  static String get logo {
    switch (appFlavor) {
      case Flavor.nopalDos:
        return 'assets/image/logo_nopal.png';
      case Flavor.maaKitchen:
        return 'assets/image/logo_maa.png';
      default:
        return 'assets/image/logo_nopal.png';
    }
  }
}
