import 'package:flutter/cupertino.dart';

class ConfigModel {
  String restaurantName;
  String restaurantLogo;
  String restaurantAddress;
  String restaurantPhone;
  String restaurantEmail;
  String currencySymbol;
  double deliveryCharge;
  double taxFee;
  String cashOnDelivery;
  String digitalPayment;
  String termsAndConditions;
  String privacyPolicy;
  String aboutUs;
  bool emailVerification;
  bool phoneVerification;
  String currencySymbolPosition;
  bool maintenanceMode;
  String countryCode;
  bool selfPickup;
  bool homeDelivery;
  double minimumOrderValue;
  String softwareVersion;
  String footerCopyright;
  String timeZone;
  int decimalPointSettings;
  int scheduleOrderSlotDuration;
  String timeFormat;
  BaseUrls? baseUrls;
  RestaurantLocationCoverage? restaurantLocationCoverage;
  SocialStatus? socialLoginStatus;
  DeliveryManagement? deliveryManagement;
  List<Branches>? branches;
  List<BannerForRestaurantWebApp>? bannerForRestaurantWebApp;
  List<RestaurantScheduleTime> restaurantScheduleTime;
  PlayStoreConfig? playStoreConfig;
  AppStoreConfig? appStoreConfig;
  List<SocialMediaLink>? socialMediaLink;

  ConfigModel({
    required this.restaurantName,
    required this.restaurantLogo,
    required this.restaurantAddress,
    required this.restaurantPhone,
    required this.restaurantEmail,
    required this.currencySymbol,
    required this.deliveryCharge,
    required this.taxFee,
    required this.cashOnDelivery,
    required this.digitalPayment,
    required this.termsAndConditions,
    required this.privacyPolicy,
    required this.aboutUs,
    required this.emailVerification,
    required this.phoneVerification,
    required this.currencySymbolPosition,
    required this.maintenanceMode,
    required this.countryCode,
    required this.minimumOrderValue,
    required this.selfPickup,
    required this.homeDelivery,
    required this.scheduleOrderSlotDuration,
    required this.timeFormat,
    required this.restaurantScheduleTime,
    this.socialLoginStatus,
    this.baseUrls,
    this.restaurantLocationCoverage,
    this.deliveryManagement,
    this.branches,
    this.bannerForRestaurantWebApp,
    this.softwareVersion = '',
    this.footerCopyright = '',
    this.timeZone = '',
    this.decimalPointSettings = 1,
    this.playStoreConfig,
    this.appStoreConfig,
    this.socialMediaLink,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    final cm = ConfigModel(
        restaurantName: json['restaurant_name'],
        restaurantLogo: json['restaurant_logo'],
        restaurantAddress: json['restaurant_address'],
        restaurantPhone: json['restaurant_phone'],
        restaurantEmail: json['restaurant_email'],
        baseUrls: json['base_urls'] != null ? BaseUrls.fromJson(json['base_urls']) : null,
        currencySymbol: json['currency_symbol'],
        deliveryCharge: json['delivery_charge'].toDouble(),
        cashOnDelivery: json['cash_on_delivery'],
        digitalPayment: json['digital_payment'],
        termsAndConditions: json['terms_and_conditions'],
        privacyPolicy: json['privacy_policy'],
        aboutUs: json['about_us'],
        emailVerification: json['email_verification'],
        phoneVerification: json['phone_verification'],
        taxFee: json['service_fee_estimated_tax'],
        currencySymbolPosition: json['currency_symbol_position'],
        maintenanceMode: json['maintenance_mode'],
        countryCode: json['country'],
        selfPickup: json['self_pickup'],
        homeDelivery: json['delivery'],
        timeZone: json['time_zone'] ?? '',
        minimumOrderValue: json['minimum_order_value'] != null ? json['minimum_order_value'].toDouble() : 0,
        scheduleOrderSlotDuration: json['schedule_order_slot_duration'].runtimeType == int
            ? json['schedule_order_slot_duration']
            : int.tryParse(json['schedule_order_slot_duration'].toString()) ?? 30,
        timeFormat: json['time_format']?.toString() ?? '12',
        restaurantScheduleTime: List<RestaurantScheduleTime>.from(
          json["restaurant_schedule_time"].map((x) => RestaurantScheduleTime.fromJson(x)),
        ),
        restaurantLocationCoverage: json['restaurant_location_coverage'] != null
            ? RestaurantLocationCoverage.fromJson(json['restaurant_location_coverage'])
            : null,
        deliveryManagement:
            json['delivery_management'] != null ? DeliveryManagement.fromJson(json['delivery_management']) : null,
        playStoreConfig: json['play_store_config'] != null ? PlayStoreConfig.fromJson(json['play_store_config']) : null,
        appStoreConfig: json['app_store_config'] != null ? AppStoreConfig.fromJson(json['app_store_config']) : null,
        softwareVersion: json['software_version'] ?? '',
        footerCopyright: json['footer_text'] ?? '',
        decimalPointSettings: json['decimal_point_settings'] ?? 1,
        socialLoginStatus: json['social_login'] != null ? SocialStatus.fromJson(json['social_login']) : null);

    if (json['branches'] != null) {
      final branches = <Branches>[];
      json['branches'].forEach((v) {
        branches.add(Branches.fromJson(v));
      });
      cm.branches = branches;
    }
    if (json['banner_for_restaurant_web_app'] != null) {
      final bannerForRestaurantWebApp = <BannerForRestaurantWebApp>[];
      json['banner_for_restaurant_web_app'].forEach((v) {
        bannerForRestaurantWebApp.add(BannerForRestaurantWebApp.fromJson(v));
      });
      cm.bannerForRestaurantWebApp = bannerForRestaurantWebApp;
    }
    if (json['social_media_link'] != null) {
      final socialMediaLink = <SocialMediaLink>[];
      json['social_media_link'].forEach((v) {
        socialMediaLink.add(SocialMediaLink.fromJson(v));
      });
      cm.socialMediaLink = socialMediaLink;
    }
    debugPrint('social login status: ${json['social_login']}');
    return cm;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant_name'] = restaurantName;
    data['restaurant_logo'] = restaurantLogo;
    data['restaurant_address'] = restaurantAddress;
    data['restaurant_phone'] = restaurantPhone;
    data['restaurant_email'] = restaurantEmail;
    data['currency_symbol'] = currencySymbol;
    data['delivery_charge'] = deliveryCharge;
    data['cash_on_delivery'] = cashOnDelivery;
    data['digital_payment'] = digitalPayment;
    data['terms_and_conditions'] = termsAndConditions;
    data['service_fee_estimated_tax'] = taxFee;
    data['privacy_policy'] = privacyPolicy;
    data['about_us'] = aboutUs;
    data['email_verification'] = emailVerification;
    data['phone_verification'] = phoneVerification;
    data['currency_symbol_position'] = currencySymbolPosition;
    data['banner_for_restaurant_web_app'] = bannerForRestaurantWebApp;
    data['maintenance_mode'] = maintenanceMode;
    data['country'] = countryCode;
    data['self_pickup'] = selfPickup;
    data['delivery'] = homeDelivery;
    data['minimum_order_value'] = minimumOrderValue;
    data['base_urls'] = baseUrls?.toJson();
    data['restaurant_location_coverage'] = restaurantLocationCoverage?.toJson();
    data['branches'] = branches?.map((v) => v.toJson()).toList();
    data['delivery_management'] = deliveryManagement?.toJson();
    data['play_store_config'] = playStoreConfig?.toJson();
    data['app_store_config'] = appStoreConfig?.toJson();
    data['social_media_link'] = socialMediaLink?.map((v) => v.toJson()).toList();
    data['software_version'] = softwareVersion;
    data['footer_text'] = footerCopyright;
    data['time_zone'] = timeZone;
    data['restaurant_schedule_time'] = restaurantScheduleTime;
    return data;
  }

  @override
  String toString() {
    return 'ConfigModel {\n'
        '  restaurantName: $restaurantName,\n'
        '  restaurantLogo: $restaurantLogo,\n'
        '  restaurantAddress: $restaurantAddress,\n'
        '  restaurantPhone: $restaurantPhone,\n'
        '  restaurantEmail: $restaurantEmail,\n'
        '  currencySymbol: $currencySymbol,\n'
        '  deliveryCharge: $deliveryCharge,\n'
        '  taxFee: $taxFee,\n'
        '  cashOnDelivery: $cashOnDelivery,\n'
        '  digitalPayment: $digitalPayment,\n'
        '  termsAndConditions: $termsAndConditions,\n'
        '  privacyPolicy: $privacyPolicy,\n'
        '  aboutUs: $aboutUs,\n'
        '  emailVerification: $emailVerification,\n'
        '  phoneVerification: $phoneVerification,\n'
        '  currencySymbolPosition: $currencySymbolPosition,\n'
        '  maintenanceMode: $maintenanceMode,\n'
        '  countryCode: $countryCode,\n'
        '  minimumOrderValue: $minimumOrderValue,\n'
        '  selfPickup: $selfPickup,\n'
        '  homeDelivery: $homeDelivery,\n'
        '  scheduleOrderSlotDuration: $scheduleOrderSlotDuration,\n'
        '  timeFormat: $timeFormat,\n'
        '  restaurantScheduleTime: $restaurantScheduleTime,\n'
        '  softwareVersion: $softwareVersion,\n'
        '  footerCopyright: $footerCopyright,\n'
        '  timeZone: $timeZone,\n'
        '  decimalPointSettings: $decimalPointSettings,\n'
        '  baseUrls: $baseUrls,\n'
        '  restaurantLocationCoverage: $restaurantLocationCoverage,\n'
        '  socialLoginStatus: $socialLoginStatus,\n'
        '  deliveryManagement: $deliveryManagement,\n'
        '  branches: $branches,\n'
        '  bannerForRestaurantWebApp: $bannerForRestaurantWebApp,\n'
        '  playStoreConfig: $playStoreConfig,\n'
        '  appStoreConfig: $appStoreConfig,\n'
        '  socialMediaLink: $socialMediaLink,\n'
        '}';
  }
}

class BaseUrls {
  String productImageUrl;
  String customerImageUrl;
  String bannerImageUrl;
  String categoryImageUrl;
  String categoryBannerImageUrl;
  String reviewImageUrl;
  String notificationImageUrl;
  String restaurantImageUrl;
  String deliveryManImageUrl;
  String chatImageUrl;
  String offerUrl;
  String branchImageUrl;
  String orderDeliveryImageUrl;

  BaseUrls({
    required this.productImageUrl,
    required this.customerImageUrl,
    required this.bannerImageUrl,
    required this.categoryImageUrl,
    required this.categoryBannerImageUrl,
    required this.reviewImageUrl,
    required this.notificationImageUrl,
    required this.restaurantImageUrl,
    required this.deliveryManImageUrl,
    required this.chatImageUrl,
    required this.offerUrl,
    required this.branchImageUrl,
    required this.orderDeliveryImageUrl,
  });

  factory BaseUrls.fromJson(Map<String, dynamic> json) {
    return BaseUrls(
      productImageUrl: json['product_image_url'] ?? '',
      customerImageUrl: json['customer_image_url'] ?? '',
      bannerImageUrl: json['banner_image_url'] ?? '',
      categoryImageUrl: json['category_image_url'] ?? '',
      categoryBannerImageUrl: json['category_banner_image_url'] ?? '',
      reviewImageUrl: json['review_image_url'] ?? '',
      notificationImageUrl: json['notification_image_url'] ?? '',
      restaurantImageUrl: json['restaurant_image_url'] ?? '',
      deliveryManImageUrl: json['delivery_man_image_url'] ?? '',
      chatImageUrl: json['chat_image_url'] ?? '',
      offerUrl: json['offer_image_url'] ?? '',
      branchImageUrl: json['branch_image_url'] ?? '',
      orderDeliveryImageUrl: json['delivered_order_image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_image_url'] = productImageUrl;
    data['customer_image_url'] = customerImageUrl;
    data['banner_image_url'] = bannerImageUrl;
    data['category_image_url'] = categoryImageUrl;
    data['review_image_url'] = reviewImageUrl;
    data['notification_image_url'] = notificationImageUrl;
    data['restaurant_image_url'] = restaurantImageUrl;
    data['delivery_man_image_url'] = deliveryManImageUrl;
    data['chat_image_url'] = chatImageUrl;
    data['offer_image_url'] = offerUrl;
    data['branch_image_url'] = branchImageUrl;
    data['delivered_order_image_url'] = orderDeliveryImageUrl;
    return data;
  }
}

class BannerForRestaurantWebApp {
  final int id;
  final String title;
  final String? description;
  final String? mobileViewDescription;

  final List<String> image;
  final int status;
  final int restaurantId;
  final String bannerType;
  final int isMobileView;
  final String? buttonText;
  final String? buttonLink;

  BannerForRestaurantWebApp({
    required this.id,
    required this.title,
    this.description,
    required this.image,
    required this.status,
    required this.restaurantId,
    required this.bannerType,
    required this.isMobileView,
    this.buttonText,
    this.buttonLink,
    this.mobileViewDescription,
  });

  BannerForRestaurantWebApp copyWith({
    int? id,
    String? title,
    String? description,
    String? mobileViewDescription,
    List<String>? image,
    int? status,
    int? restaurantId,
    String? bannerType,
    int? isMobileView,
    String? buttonText,
    String? buttonLink,
  }) {
    return BannerForRestaurantWebApp(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      mobileViewDescription: mobileViewDescription ?? this.mobileViewDescription,
      image: image ?? this.image,
      status: status ?? this.status,
      restaurantId: restaurantId ?? this.restaurantId,
      bannerType: bannerType ?? this.bannerType,
      isMobileView: isMobileView ?? this.isMobileView,
      buttonText: buttonText ?? this.buttonText,
      buttonLink: buttonLink ?? this.buttonLink,
    );
  }

  factory BannerForRestaurantWebApp.fromJson(Map<String, dynamic> json) {
    return BannerForRestaurantWebApp(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      mobileViewDescription: json["mobile_view_description"],
      image: List<String>.from(json["image"].map((x) => x)),
      status: json["status"],
      restaurantId: json["restaurant_id"],
      bannerType: json["banner_type"],
      isMobileView: json["is_mobile_view"],
      buttonText: json["button_text"],
      buttonLink: json["button_link"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "mobile_view_description": mobileViewDescription,
      "image": List<dynamic>.from(image.map((x) => x)),
      "status": status,
      "restaurant_id": restaurantId,
      "banner_type": bannerType,
      "is_mobile_view": isMobileView,
      "button_text": buttonText,
      "button_link": buttonLink,
    };
  }
}

class RestaurantLocationCoverage {
  String longitude;
  String latitude;
  double coverage;

  RestaurantLocationCoverage({
    required this.longitude,
    required this.latitude,
    required this.coverage,
  });

  factory RestaurantLocationCoverage.fromJson(Map<String, dynamic> json) {
    return RestaurantLocationCoverage(
      longitude: json['longitude'],
      latitude: json['latitude'],
      coverage: json['coverage'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['coverage'] = coverage;
    return data;
  }
}

class Branches {
  int id;
  String? name;
  String email;
  String longitude;
  String latitude;
  String? address;
  double coverage;
  String? coverImage;
  String image;
  bool status;

  Branches({
    required this.id,
    this.name,
    required this.email,
    required this.longitude,
    required this.latitude,
    this.address,
    required this.coverage,
    this.coverImage,
    required this.image,
    required this.status,
  });

  factory Branches.fromJson(Map<String, dynamic> json) {
    return Branches(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      address: json['address'],
      coverage: json['coverage'].toDouble(),
      image: json['image'],
      status: json['status'],
      coverImage: json['cover_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['address'] = address;
    data['coverage'] = coverage;
    data['image'] = image;
    data['status'] = status;
    return data;
  }
}

class BranchValue {
  final Branches branches;
  final double distance;

  BranchValue(this.branches, this.distance);
}

class DeliveryManagement {
  int status;
  double minShippingCharge;
  double shippingPerKm;

  DeliveryManagement({
    required this.status,
    required this.minShippingCharge,
    required this.shippingPerKm,
  });

  factory DeliveryManagement.fromJson(Map<String, dynamic> json) {
    return DeliveryManagement(
      status: json['status'],
      minShippingCharge: json['min_shipping_charge'].toDouble(),
      shippingPerKm: json['shipping_per_km'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['min_shipping_charge'] = minShippingCharge;
    data['shipping_per_km'] = shippingPerKm;
    return data;
  }
}

class PlayStoreConfig {
  bool status;
  String? link;
  double? minVersion;

  PlayStoreConfig({
    required this.status,
    this.link,
    this.minVersion,
  });

  factory PlayStoreConfig.fromJson(Map<String, dynamic> json) {
    return PlayStoreConfig(
      status: json['status'],
      link: json['link'],
      minVersion: double.tryParse(json['min_version'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['link'] = link;
    data['min_version'] = minVersion;
    return data;
  }
}

class AppStoreConfig {
  bool status;
  String? link;
  double? minVersion;

  AppStoreConfig({
    required this.status,
    this.link,
    this.minVersion,
  });

  factory AppStoreConfig.fromJson(Map<String, dynamic> json) {
    return AppStoreConfig(
      status: json['status'],
      link: json['link'],
      minVersion: double.tryParse(json['min_version'] ?? ''),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['link'] = link;
    data['min_version'] = minVersion;
    return data;
  }
}

class SocialMediaLink {
  int id;
  String name;
  String link;
  int status;
  String? updatedAt;

  SocialMediaLink({
    required this.id,
    required this.name,
    required this.link,
    required this.status,
    this.updatedAt,
  });

  factory SocialMediaLink.fromJson(Map<String, dynamic> json) {
    return SocialMediaLink(
      id: json['id'],
      name: json['name'],
      link: json['link'],
      status: json['status'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['link'] = link;
    data['status'] = status;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class RestaurantScheduleTime {
  String day;
  String openingTime;
  String closingTime;

  RestaurantScheduleTime({
    required this.day,
    required this.openingTime,
    required this.closingTime,
  });

  factory RestaurantScheduleTime.fromJson(Map<String, dynamic> json) {
    return RestaurantScheduleTime(
      day: json["day"].toString(),
      openingTime: json["opening_time"].toString(),
      closingTime: json["closing_time"].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "opening_time": openingTime,
      "closing_time": closingTime,
    };
  }
}

class SocialStatus {
  bool isGoogle;
  bool isFacebook;

  SocialStatus({required this.isGoogle, required this.isFacebook});

  factory SocialStatus.fromJson(Map<String, dynamic> json) {
    return SocialStatus(
      isGoogle: json['google'].toString() == '1',
      isFacebook: json['facebook'].toString() == '1',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['google'] = isGoogle;
    data['facebook'] = isFacebook;
    return data;
  }
}
