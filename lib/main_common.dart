import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/language_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/notification_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/router_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/app_localization.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/provider_barrel.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  Stripe.publishableKey = AppConstants.public_stripe_key;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  await Firebase.initializeApp();

  await di.init();
  int? orderID;
  try {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );

    final remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    orderID = int.tryParse(remoteMessage?.notification?.titleLocKey ?? '');

    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  } catch (e) {
    debugPrint('ERROR IN MAIN $e');
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AllCategoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProductProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CartProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<PaymentProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ProfileProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CouponProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WishListProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NewsLetterProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<TimerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BranchProvider>()),
    ],
    child: MyApp(orderId: orderID),
  ));
}

class MyApp extends StatefulWidget {
  final int? orderId;

  const MyApp({super.key, required this.orderId});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    RouterHelper.setupRouter();

    Provider.of<LocationProvider>(context, listen: false).checkPermission(
      () => Provider.of<LocationProvider>(context, listen: false).getCurrentLocation(context, false),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> locals = [];
    for (LanguageModel language in AppConstants.languages) {
      locals.add(Locale(language.languageCode, language.countryCode));
    }

    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        return MaterialApp(
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
