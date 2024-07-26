import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/repo_barrel.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/provider_barrel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'data/repository/loyality_points_repo.dart';
import 'data/repository/news_letter_repo.dart';
import 'data/repository/payment_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => HttpClient(F.BASE_URL, loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), httpClient: sl()));
  sl.registerLazySingleton(() => CategoryRepo(httpClient: sl()));
  sl.registerLazySingleton(() => BannerRepo(httpClient: sl()));
  sl.registerLazySingleton(() => ProductRepo(httpClient: sl()));
  sl.registerLazySingleton(() => LoyalityPointsRepo(httpClient: sl()));
  sl.registerLazySingleton(() => PaymentRepo(httpClient: sl()));
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(() => OnBoardingRepo(httpClient: sl()));
  sl.registerLazySingleton(() => CartRepo(sharedPreferences: sl()));
  sl.registerLazySingleton(() => OrderRepo(httpClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepo(httpClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => AuthRepo(httpClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => LocationRepo(httpClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SetMenuRepo(httpClient: sl()));
  sl.registerLazySingleton(() => ProfileRepo(httpClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SearchRepo(httpClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => NotificationRepo(httpClient: sl()));
  sl.registerLazySingleton(() => CouponRepo(httpClient: sl()));
  sl.registerLazySingleton(() => WishListRepo(httpClient: sl()));
  sl.registerLazySingleton(() => NewsLetterRepo(httpClient: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => OnBoardingProvider(onboardingRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(() => CategoryProvider(categoryRepo: sl()));
  sl.registerFactory(() => AllCategoryProvider(categoryRepo: sl()));
  sl.registerFactory(() => ProductProvider(productRepo: sl()));
  sl.registerFactory(() => CartProvider(cartRepo: sl()));
  sl.registerFactory(() => OrderProvider(orderRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(() => PaymentProvider(paymentRepo: sl()));
  sl.registerFactory(() => ChatProvider(chatRepo: sl(), notificationRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => LocationProvider(sharedPreferences: sl(), locationRepo: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => NotificationProvider(notificationRepo: sl()));
  sl.registerFactory(() => WishListProvider(wishListRepo: sl()));
  sl.registerFactory(() => CouponProvider(couponRepo: sl()));
  sl.registerFactory(() => NewsLetterProvider(newsLetterRepo: sl()));
  sl.registerLazySingleton(() => TimerProvider());
  sl.registerLazySingleton(() => BranchProvider(splashRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
