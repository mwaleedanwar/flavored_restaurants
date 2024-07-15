import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/notification_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/router_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/app_localization.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/provider_barrel.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'di_container.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

late AndroidNotificationChannel channel;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = AppConstants.public_stripe_key;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyDYJJpId7vKLxxfxOSQC9rGbwbh16EGzac",
      authDomain: "scalecafe-e41d3.firebaseapp.com",
      projectId: "scalecafe-e41d3",
      storageBucket: "scalecafe-e41d3.appspot.com",
      messagingSenderId: "321185419116",
      appId: "1:321185419116:web:fc43476afcc03630dded49",
      measurementId: "G-1TMNY6FWDK",
    ));

    // await FacebookAuth.instance.webAndDesktopInitialize(
    //   appId: "482889663914976",
    //   cookie: true,
    //   xfbml: true,
    //   version: "v13.0",
    // );
  }
  await di.init();
  int? orderID;
  try {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.high,
      );
    }
    final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      orderID = remoteMessage.notification?.titleLocKey != null
          ? int.tryParse(remoteMessage.notification!.titleLocKey ?? '')
          : null;
    }
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  } catch (e) {
    debugPrint("ERROR IN MAIN $e");
    rethrow;
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AllCategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BannerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LoyalityPointsProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CartProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<PaymentProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SetMenuProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CouponProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WishListProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SearchProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NewsLetterProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TimerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BranchProvider>()),
    ],
    child: MyApp(orderId: orderID, isWeb: !kIsWeb),
  ));
}

class MyApp extends StatefulWidget {
  final int? orderId;
  final bool isWeb;

  const MyApp({super.key, required this.orderId, required this.isWeb});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    RouterHelper.setupRouter();

    if (kIsWeb) {
      Provider.of<SplashProvider>(context, listen: false).initSharedData();
      Provider.of<CartProvider>(context, listen: false).getCartData();
      Provider.of<SplashProvider>(context, listen: false).getPolicyPage(context);

      if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      }

      _route();
    }
    Provider.of<LocationProvider>(context, listen: false).checkPermission(
      () => Provider.of<LocationProvider>(context, listen: false)
          .getCurrentLocation(context, false)
          .then((currentPosition) {}),
      context,
    );
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initConfig(context).then((bool isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: ResponsiveHelper.isMobilePhone() ? 1 : 0), () async {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            Provider.of<AuthProvider>(context, listen: false).updateToken();
            await Provider.of<WishListProvider>(context, listen: false).initWishList(
              context,
              Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (var language in AppConstants.languages) {
      locals.add(Locale(language.languageCode, language.countryCode));
    }

    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        return (kIsWeb && splashProvider.configModel == null)
            ? const SizedBox()
            : MaterialApp(
                initialRoute: ResponsiveHelper.isMobilePhone() ? Routes.getSplashRoute() : Routes.getMainRoute(),
                onGenerateRoute: RouterHelper.router.generator,
                title: splashProvider.configModel != null ? splashProvider.configModel!.restaurantName : F.appName,
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                theme: Provider.of<ThemeProvider>(context).darkTheme ? F.themeDark : F.themeLight,
                locale: Provider.of<LocalizationProvider>(context).locale,
                localizationsDelegates: const [
                  AppLocalization.delegate,
                ],
                supportedLocales: locals,
                scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown
                }),
              );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class Get {
  static BuildContext get context => navigatorKey.currentContext!;

  static NavigatorState get navigator => navigatorKey.currentState!;
}
