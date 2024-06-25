import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/theme/dark_theme.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/theme/light_theme.dart';

enum Flavor {
  nopalDos,
  maaKitchen,
  cafeSantorini,
  halalChinaBox,
  apnaaBazaar,
  willybSteakHouse,
  chaatHouse,
  kabsah,
  fifthElement,
  alladinGrill,
  jaxSpice,
  afGrill,
}

class F {
  static Flavor appFlavor;

  static String get appName {
    switch (appFlavor) {
      case Flavor.nopalDos:
        return 'Nopal Dos';
      case Flavor.maaKitchen:
        return 'Maa Kitchen';
      case Flavor.cafeSantorini:
        return 'Cafe Santorini';
      case Flavor.halalChinaBox:
        return 'Halal China Box';
      case Flavor.apnaaBazaar:
        return 'Apnaa Bazar';
      case Flavor.willybSteakHouse:
        return 'willybsteakhouse';
      case Flavor.chaatHouse:
        return 'Chaat House';
      case Flavor.kabsah:
        return 'Kabsah';
      case Flavor.fifthElement:
        return '5th Element';
      case Flavor.alladinGrill:
        return 'Aladdin Grill';
      case Flavor.jaxSpice:
        return 'JaxSpice';
      case Flavor.afGrill:
        return 'ANF Gyros & Grill';
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
      case Flavor.cafeSantorini:
        return 'https://santorini.cafescale.app';
      case Flavor.halalChinaBox:
        return 'https://halalchinabox.cafescale.app';
      case Flavor.apnaaBazaar:
        return 'https://apnaa.cafescale.app';
      case Flavor.willybSteakHouse:
        return 'https://willybsteakhouse.cafescale.app';
      case Flavor.chaatHouse:
        return 'https://chaathouse.cafescale.app';
      case Flavor.kabsah:
        return 'https://kabsah.cafescale.app';
      case Flavor.fifthElement:
        return 'https://5thelement.cafescale.app';
      case Flavor.alladinGrill:
        return 'https://aladdin.cafescale.app';
      case Flavor.jaxSpice:
        return 'https://jaxspice.cafescale.app';
      case Flavor.afGrill:
        return 'https://anf-gyros.cafescale.app';
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
      case Flavor.cafeSantorini:
        return 3;
      case Flavor.halalChinaBox:
        return 21;
      case Flavor.apnaaBazaar:
        return 16;
      case Flavor.willybSteakHouse:
        return 26;
      case Flavor.chaatHouse:
        return 22;
      case Flavor.kabsah:
        return 8;
      case Flavor.fifthElement:
        return 20;
      case Flavor.alladinGrill:
        return 15;
      case Flavor.jaxSpice:
        return 23;
      case Flavor.afGrill:
        return 2;
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
      case Flavor.cafeSantorini:
        return const FirebaseOptions(
          apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
          authDomain: "scalecafe-e41d3.firebaseapp.com",
          projectId: "scalecafe-e41d3",
          storageBucket: "scalecafe-e41d3.appspot.com",
          messagingSenderId: "321185419116",
          appId: "1:321185419116:web:fc43476afcc03630dded49",
          measurementId: "G-1TMNY6FWDK",
        );
      case Flavor.halalChinaBox:
        return const FirebaseOptions(
          apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
          authDomain: "scalecafe-e41d3.firebaseapp.com",
          projectId: "scalecafe-e41d3",
          storageBucket: "scalecafe-e41d3.appspot.com",
          messagingSenderId: "321185419116",
          appId: "1:321185419116:web:fc43476afcc03630dded49",
          measurementId: "G-1TMNY6FWDK",
        );
      case Flavor.apnaaBazaar:
        return const FirebaseOptions(
          apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
          authDomain: "scalecafe-e41d3.firebaseapp.com",
          projectId: "scalecafe-e41d3",
          storageBucket: "scalecafe-e41d3.appspot.com",
          messagingSenderId: "321185419116",
          appId: "1:321185419116:web:fc43476afcc03630dded49",
          measurementId: "G-1TMNY6FWDK",
        );
      case Flavor.willybSteakHouse:
        return const FirebaseOptions(
          apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
          authDomain: "scalecafe-e41d3.firebaseapp.com",
          projectId: "scalecafe-e41d3",
          storageBucket: "scalecafe-e41d3.appspot.com",
          messagingSenderId: "321185419116",
          appId: "1:321185419116:web:fc43476afcc03630dded49",
          measurementId: "G-1TMNY6FWDK",
        );
      case Flavor.chaatHouse:
        return const FirebaseOptions(
          apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
          authDomain: "scalecafe-e41d3.firebaseapp.com",
          projectId: "scalecafe-e41d3",
          storageBucket: "scalecafe-e41d3.appspot.com",
          messagingSenderId: "321185419116",
          appId: "1:321185419116:web:fc43476afcc03630dded49",
          measurementId: "G-1TMNY6FWDK",
        );
      case Flavor.kabsah:
        return const FirebaseOptions(
          apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
          authDomain: "scalecafe-e41d3.firebaseapp.com",
          projectId: "scalecafe-e41d3",
          storageBucket: "scalecafe-e41d3.appspot.com",
          messagingSenderId: "321185419116",
          appId: "1:321185419116:web:fc43476afcc03630dded49",
          measurementId: "G-1TMNY6FWDK",
        );
      case Flavor.fifthElement:
        return const FirebaseOptions(
          apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
          authDomain: "scalecafe-e41d3.firebaseapp.com",
          projectId: "scalecafe-e41d3",
          storageBucket: "scalecafe-e41d3.appspot.com",
          messagingSenderId: "321185419116",
          appId: "1:321185419116:web:fc43476afcc03630dded49",
          measurementId: "G-1TMNY6FWDK",
        );
      case Flavor.alladinGrill:
        return const FirebaseOptions(
          apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
          authDomain: "scalecafe-e41d3.firebaseapp.com",
          projectId: "scalecafe-e41d3",
          storageBucket: "scalecafe-e41d3.appspot.com",
          messagingSenderId: "321185419116",
          appId: "1:321185419116:web:fc43476afcc03630dded49",
          measurementId: "G-1TMNY6FWDK",
        );
      case Flavor.jaxSpice:
        return const FirebaseOptions(
          apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
          authDomain: "scalecafe-e41d3.firebaseapp.com",
          projectId: "scalecafe-e41d3",
          storageBucket: "scalecafe-e41d3.appspot.com",
          messagingSenderId: "321185419116",
          appId: "1:321185419116:web:fc43476afcc03630dded49",
          measurementId: "G-1TMNY6FWDK",
        );
      case Flavor.afGrill:
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
      case Flavor.cafeSantorini:
        return light_cafe_santorini;
      case Flavor.halalChinaBox:
        return light_halal_china_box;
      case Flavor.apnaaBazaar:
        return light_apnaa_bazaar;
      case Flavor.willybSteakHouse:
        return light_willy_b_steak_house;
      case Flavor.chaatHouse:
        return light_chaat_house;
      case Flavor.kabsah:
        return light_kabsah_theme;
      case Flavor.fifthElement:
        return light_5th_element;
      case Flavor.alladinGrill:
        return light_alladin_grill;
      case Flavor.jaxSpice:
        return light_jax_spice;
      case Flavor.afGrill:
        return light_af_grills;
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
      case Flavor.cafeSantorini:
        return dark_cafe_santorini;
      case Flavor.halalChinaBox:
        return dark_halal_china_box;
      case Flavor.apnaaBazaar:
        return dark_apnaa_bazaar;
      case Flavor.willybSteakHouse:
        return dark_willy_b_steak_house;
      case Flavor.chaatHouse:
        return dark_chaat_house;
      case Flavor.kabsah:
        return dark_kabsah_theme;
      case Flavor.fifthElement:
        return dark_5th_element;
      case Flavor.alladinGrill:
        return dark_alladin_grill;
      case Flavor.jaxSpice:
        return dark_jax_spice;
      case Flavor.afGrill:
        return dark_af_grills;
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
      case Flavor.cafeSantorini:
        return const Color(0xFF8B288C);
      case Flavor.halalChinaBox:
        return const Color(0xFFa60f0f);
      case Flavor.apnaaBazaar:
        return const Color(0xFFC42127);
      case Flavor.willybSteakHouse:
        return const Color(0xFF8F000A);
      case Flavor.chaatHouse:
        return const Color(0xFFF9333E);
      case Flavor.kabsah:
        return const Color(0xFFDD9933);
      case Flavor.fifthElement:
        return const Color(0xFFf88218);
      case Flavor.alladinGrill:
        return const Color(0xFF950103);
      case Flavor.jaxSpice:
        return const Color(0xFFf8ac6a);
      case Flavor.afGrill:
        return const Color(0xFFED6067);
      default:
        return const Color(0xFF697b18);
    }
  }

  static String get logo {
    switch (appFlavor) {
      case Flavor.nopalDos:
        return 'assets/image/logo_nopal.png';
      case Flavor.maaKitchen:
        return 'assets/image/logo_maa.png';
      case Flavor.cafeSantorini:
        return 'assets/image/logo_santo.png';
      case Flavor.halalChinaBox:
        return 'assets/image/logo_halal_china_box.png';
      case Flavor.apnaaBazaar:
        return 'assets/image/logo_apnaa_bazaar.png';
      case Flavor.willybSteakHouse:
        return 'assets/image/logo_willyb.png';
      case Flavor.chaatHouse:
        return 'assets/image/logo_chaat_house.png';
      case Flavor.fifthElement:
        return 'assets/image/logo_5th_element.png';
      case Flavor.alladinGrill:
        return 'assets/image/logo_alladin_grill.png';
      case Flavor.jaxSpice:
        return 'assets/image/logo_jax_spice.png';
      case Flavor.afGrill:
        return 'assets/image/logo_af_grill.png';
      default:
        return 'assets/image/logo_nopal.png';
    }
  }
}
