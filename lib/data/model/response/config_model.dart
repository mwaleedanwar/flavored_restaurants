import 'package:flutter/cupertino.dart';

class ConfigModel {
  String _restaurantName;
  String _restaurantLogo;
  String _restaurantAddress;
  String _restaurantPhone;
  String _restaurantEmail;
  BaseUrls _baseUrls;
  String _currencySymbol;
  double _deliveryCharge;
  double _taxFee;
  String _cashOnDelivery;
  String _digitalPayment;
  String _termsAndConditions;
  String _privacyPolicy;
  String _aboutUs;
  bool _emailVerification;
  bool _phoneVerification;
  String _currencySymbolPosition;
  bool _maintenanceMode;
  String _countryCode;
  bool _selfPickup;
  bool _homeDelivery;
  RestaurantLocationCoverage _restaurantLocationCoverage;
  double _minimumOrderValue;
  List<Branches> _branches;
   List<BannerForRestaurantWebApp> _bannerForRestaurantWebApp;

  DeliveryManagement _deliveryManagement;
  PlayStoreConfig _playStoreConfig;
  AppStoreConfig _appStoreConfig;
  List<SocialMediaLink> _socialMediaLink;
  String _softwareVersion;
  String _footerCopyright;
  String _timeZone;
  int _decimalPointSettings;
  List<RestaurantScheduleTime> _restaurantScheduleTime;
  int _scheduleOrderSlotDuration;
  String _timeFormat;
  SocialStatus _socialLoginStatus;


  ConfigModel(
      {String restaurantName,
        String restaurantLogo,
        String restaurantAddress,
        String restaurantPhone,
        String restaurantEmail,
        BaseUrls baseUrls,
        String currencySymbol,
        double deliveryCharge,
        double texFee,
        String cashOnDelivery,
        String digitalPayment,
        String termsAndConditions,
        String privacyPolicy,
        String aboutUs,
        bool emailVerification,
        bool phoneVerification,
        String currencySymbolPosition,
        bool maintenanceMode,
        String countryCode,
        RestaurantLocationCoverage restaurantLocationCoverage,
        double minimumOrderValue,
        List<Branches> branches,
        List<BannerForRestaurantWebApp> bannerForRestaurantWebApp,

        bool selfPickup,
        bool homeDelivery,
        DeliveryManagement deliveryManagement,
        PlayStoreConfig playStoreConfig,
        AppStoreConfig appStoreConfig,
        List<SocialMediaLink> socialMediaLink,
        String softwareVersion,
        String footerCopyright,
        String timeZone,
        int decimalPointSettings,
        List<RestaurantScheduleTime> restaurantScheduleTime,
        int scheduleOrderSlotDuration,
        String timeFormat,
        SocialStatus socialLoginStatus,
      }) {
    this._restaurantName = restaurantName;
    this._restaurantLogo = restaurantLogo;
    this._restaurantAddress = restaurantAddress;
    this._restaurantPhone = restaurantPhone;
    this._restaurantEmail = restaurantEmail;
    this._baseUrls = baseUrls;
    this._currencySymbol = currencySymbol;
    this._deliveryCharge = deliveryCharge;
    this._cashOnDelivery = cashOnDelivery;
    this._digitalPayment = digitalPayment;
    this._termsAndConditions = termsAndConditions;
    this._aboutUs = aboutUs;
    this._privacyPolicy = privacyPolicy;
    this._restaurantLocationCoverage = restaurantLocationCoverage;
    this._minimumOrderValue = minimumOrderValue;
    this._branches = branches;
    this._emailVerification = emailVerification;
    this._phoneVerification = phoneVerification;
    this._currencySymbolPosition = currencySymbolPosition;
    this._maintenanceMode = maintenanceMode;
    this._countryCode = countryCode;
    this._taxFee=texFee;
    this._selfPickup = selfPickup;
    this._homeDelivery = homeDelivery;
    this._deliveryManagement = deliveryManagement;
    if (playStoreConfig != null) {
      this._playStoreConfig = playStoreConfig;
    }
    if (appStoreConfig != null) {
      this._appStoreConfig = appStoreConfig;
    }
    if (socialMediaLink != null) {
      this._socialMediaLink = socialMediaLink;
    }
    this._bannerForRestaurantWebApp=bannerForRestaurantWebApp;

    this._softwareVersion = softwareVersion ?? '';
    this._footerCopyright = footerCopyright ?? '';
    this._timeZone = timeZone ?? '';
    this._decimalPointSettings = decimalPointSettings ?? 1;
    this._restaurantScheduleTime = restaurantScheduleTime;
    this._scheduleOrderSlotDuration = scheduleOrderSlotDuration;
    this._timeFormat = timeFormat;
  }

  String get restaurantName => _restaurantName;
  String get restaurantLogo => _restaurantLogo;
  String get restaurantAddress => _restaurantAddress;
  String get restaurantPhone => _restaurantPhone;
  String get restaurantEmail => _restaurantEmail;
  BaseUrls get baseUrls => _baseUrls;
  String get currencySymbol => _currencySymbol;
  double get deliveryCharge => _deliveryCharge;
  double get texFee => _taxFee;
  String get cashOnDelivery => _cashOnDelivery;
  String get digitalPayment => _digitalPayment;
  String get termsAndConditions => _termsAndConditions;
  String get aboutUs=> _aboutUs;
  String get privacyPolicy=> _privacyPolicy;
  RestaurantLocationCoverage get restaurantLocationCoverage => _restaurantLocationCoverage;
  double get minimumOrderValue => _minimumOrderValue;
  List<Branches> get branches => _branches;
  List<BannerForRestaurantWebApp> get bannerForRestaurantWebApp => _bannerForRestaurantWebApp;

  bool get emailVerification => _emailVerification;
  bool get phoneVerification => _phoneVerification;
  String get currencySymbolPosition => _currencySymbolPosition;
  bool get maintenanceMode => _maintenanceMode;
  String get countryCode => _countryCode;
  bool get selfPickup => _selfPickup;
  bool get homeDelivery => _homeDelivery;
  DeliveryManagement get deliveryManagement => _deliveryManagement;
  PlayStoreConfig get playStoreConfig => _playStoreConfig;
  AppStoreConfig get appStoreConfig => _appStoreConfig;
  List<SocialMediaLink> get socialMediaLink => _socialMediaLink;
  String get softwareVersion => _softwareVersion;
  String get footerCopyright => _footerCopyright;
  String get timeZone  => _timeZone;
  int get decimalPointSettings => _decimalPointSettings;
  List<RestaurantScheduleTime> get restaurantScheduleTime => _restaurantScheduleTime;
  int get scheduleOrderSlotDuration => _scheduleOrderSlotDuration;
  String get timeFormat => _timeFormat;
  SocialStatus get socialLoginStatus => _socialLoginStatus;


  ConfigModel.fromJson(Map<String, dynamic> json) {
    _restaurantName = json['restaurant_name'];
    _restaurantLogo = json['restaurant_logo'];
    _restaurantAddress = json['restaurant_address'];
    _restaurantPhone = json['restaurant_phone'];
    _restaurantEmail = json['restaurant_email'];
    _baseUrls = json['base_urls'] != null
        ? new BaseUrls.fromJson(json['base_urls'])
        : null;
    _currencySymbol = json['currency_symbol'];
    _deliveryCharge = json['delivery_charge'].toDouble();
    _cashOnDelivery = json['cash_on_delivery'];
    _digitalPayment = json['digital_payment'];
    _termsAndConditions = json['terms_and_conditions'];
    _privacyPolicy = json['privacy_policy'];
    _aboutUs = json['about_us'];
    _emailVerification = json['email_verification'];
    _phoneVerification = json['phone_verification'];
    _taxFee = json['service_fee_estimated_tax'];
    _currencySymbolPosition = json['currency_symbol_position'];
    _maintenanceMode = json['maintenance_mode'];
    _countryCode = json['country'];
    _selfPickup = json['self_pickup'];
    _homeDelivery = json['delivery'];
    _restaurantLocationCoverage = json['restaurant_location_coverage'] != null
        ? new RestaurantLocationCoverage.fromJson(json['restaurant_location_coverage']) : null;
    _minimumOrderValue = json['minimum_order_value'] != null ? json['minimum_order_value'].toDouble() : 0;
    if (json['branches'] != null) {
      _branches = [];
      json['branches'].forEach((v) {
        _branches.add(new Branches.fromJson(v));
      });
    }
    if (json['banner_for_restaurant_web_app'] != null) {
      _bannerForRestaurantWebApp = [];
      json['banner_for_restaurant_web_app'].forEach((v) {
        _bannerForRestaurantWebApp.add(new BannerForRestaurantWebApp.fromJson(v));
      });
    }
    _deliveryManagement = json['delivery_management'] != null
        ? new DeliveryManagement.fromJson(json['delivery_management'])
        : null;
    _playStoreConfig = json['play_store_config'] != null
        ? new PlayStoreConfig.fromJson(json['play_store_config'])
        : null;
    _appStoreConfig = json['app_store_config'] != null
        ? new AppStoreConfig.fromJson(json['app_store_config'])
        : null;

    if (json['social_media_link'] != null) {
      _socialMediaLink = <SocialMediaLink>[];
      json['social_media_link'].forEach((v) {
        _socialMediaLink.add(new SocialMediaLink.fromJson(v));
      });
    }
    if(json['software_version'] !=null){
      _softwareVersion = json['software_version'];
    }
    if(json['footer_text']!=null){
      _footerCopyright = json['footer_text'];
    }
    _timeZone = json['time_zone'];
    _decimalPointSettings = json['decimal_point_settings'] ?? 1;

    _restaurantScheduleTime = List<RestaurantScheduleTime>.from(json["restaurant_schedule_time"].map((x) => RestaurantScheduleTime.fromJson(x)));

    // try {
    // }catch(_){
    //   _restaurantScheduleTime = [];
    // }

    try {
      _scheduleOrderSlotDuration = json['schedule_order_slot_duration'] ?? 30;
    }catch(_){
      _scheduleOrderSlotDuration = int.tryParse(json['schedule_order_slot_duration'] ?? 30);
    }

    _timeFormat =  json['time_format'].toString() ?? '12';
    debugPrint('social login status: ${json['social_login']}');

    if(json['social_login'] != null) {
      _socialLoginStatus = SocialStatus.fromJson(json['social_login']) ;
    }




  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_name'] = this._restaurantName;
    data['restaurant_logo'] = this._restaurantLogo;
    data['restaurant_address'] = this._restaurantAddress;
    data['restaurant_phone'] = this._restaurantPhone;
    data['restaurant_email'] = this._restaurantEmail;
    if (this._baseUrls != null) {
      data['base_urls'] = this._baseUrls.toJson();
    }
    data['currency_symbol'] = this._currencySymbol;
    data['delivery_charge'] = this._deliveryCharge;
    data['cash_on_delivery'] = this._cashOnDelivery;
    data['digital_payment'] = this._digitalPayment;
    data['terms_and_conditions'] = this._termsAndConditions;
    data['service_fee_estimated_tax'] = this._taxFee;
    data['privacy_policy'] = this.privacyPolicy;
    data['about_us'] = this.aboutUs;
    data['email_verification'] = this.emailVerification;
    data['phone_verification'] = this.phoneVerification;
    data['currency_symbol_position'] = this.currencySymbolPosition;
    data['banner_for_restaurant_web_app'] = this.bannerForRestaurantWebApp;
    data['maintenance_mode'] = this.maintenanceMode;
    data['country'] = this.countryCode;
    data['self_pickup'] = this.selfPickup;
    data['delivery'] = this.homeDelivery;
    if (this._restaurantLocationCoverage != null) {
      data['restaurant_location_coverage'] = this._restaurantLocationCoverage.toJson();
    }
    data['minimum_order_value'] = this._minimumOrderValue;
    if (this._branches != null) {
      data['branches'] = this._branches.map((v) => v.toJson()).toList();
    }
    if (this._deliveryManagement != null) {
      data['delivery_management'] = this._deliveryManagement.toJson();
    }
    if (this._playStoreConfig != null) {
      data['play_store_config'] = this._playStoreConfig.toJson();
    }
    if (this._appStoreConfig != null) {
      data['app_store_config'] = this._appStoreConfig.toJson();
    }
    if (this._socialMediaLink != null) {
      data['social_media_link'] =
          this._socialMediaLink.map((v) => v.toJson()).toList();
    }
    data['software_version'] = this._softwareVersion;
    data['footer_text'] = this._footerCopyright;
    data['time_zone'] = this._timeZone;
    data['restaurant_schedule_time'] = this._restaurantScheduleTime;
    return data;
  }
}

class BaseUrls {
  String _productImageUrl;
  String _customerImageUrl;
  String _bannerImageUrl;
  String _categoryImageUrl;
  String _categoryBannerImageUrl;
  String _reviewImageUrl;
  String _notificationImageUrl;
  String _restaurantImageUrl;
  String _deliveryManImageUrl;
  String _chatImageUrl;
  String _offerUrl;
  String _branchImageUrl;
  String _orderDeliveryImageUrl;

  BaseUrls(
      {String productImageUrl,
        String customerImageUrl,
        String bannerImageUrl,
        String categoryImageUrl,
        String categoryBannerImageUrl,
        String reviewImageUrl,
        String notificationImageUrl,
        String restaurantImageUrl,
        String deliveryManImageUrl,
        String chatImageUrl,
        String offerUrl,
        String branchImageUrl,
        String orderDeliveryImageUrl,

      }) {
    this._productImageUrl = productImageUrl;
    this._customerImageUrl = customerImageUrl;
    this._bannerImageUrl = bannerImageUrl;
    this._categoryImageUrl = categoryImageUrl;
    this._categoryBannerImageUrl = categoryBannerImageUrl;
    this._reviewImageUrl = reviewImageUrl;
    this._notificationImageUrl = notificationImageUrl;
    this._restaurantImageUrl = restaurantImageUrl;
    this._deliveryManImageUrl = deliveryManImageUrl;
    this._chatImageUrl = chatImageUrl;
    this._offerUrl = offerUrl;
    this._branchImageUrl = branchImageUrl;
    this._orderDeliveryImageUrl = orderDeliveryImageUrl;

  }

  String get productImageUrl => _productImageUrl;
  String get customerImageUrl => _customerImageUrl;
  String get bannerImageUrl => _bannerImageUrl;
  String get categoryImageUrl => _categoryImageUrl;
  String get categoryBannerImageUrl => _categoryBannerImageUrl;
  String get reviewImageUrl => _reviewImageUrl;
  String get notificationImageUrl => _notificationImageUrl;
  String get restaurantImageUrl => _restaurantImageUrl;
  String get deliveryManImageUrl => _deliveryManImageUrl;
  String get chatImageUrl => _chatImageUrl;
  String get offerUrl => _offerUrl;
  String get branchImageUrl => _branchImageUrl;
  String get orderDeliveryImageUrl => _orderDeliveryImageUrl;

  BaseUrls.fromJson(Map<String, dynamic> json) {
    _productImageUrl = json['product_image_url'] ?? '';
    _customerImageUrl = json['customer_image_url'] ?? '';
    _bannerImageUrl = json['banner_image_url'] ?? '';
    _categoryImageUrl = json['category_image_url'] ?? '';
    _categoryBannerImageUrl = json['category_banner_image_url' ?? '' ];
    _reviewImageUrl = json['review_image_url'] ?? '';
    _notificationImageUrl = json['notification_image_url' ?? ''];
    _restaurantImageUrl = json['restaurant_image_url'] ?? '';
    _deliveryManImageUrl = json['delivery_man_image_url'] ?? '';
    _chatImageUrl = json['chat_image_url'] ?? '';
    _offerUrl = json['offer_image_url'] ?? '';
    _branchImageUrl = json['branch_image_url'] ?? '';
    _orderDeliveryImageUrl = json['delivered_order_image_url'] ?? '';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_image_url'] = this._productImageUrl;
    data['customer_image_url'] = this._customerImageUrl;
    data['banner_image_url'] = this._bannerImageUrl;
    data['category_image_url'] = this._categoryImageUrl;
    data['review_image_url'] = this._reviewImageUrl;
    data['notification_image_url'] = this._notificationImageUrl;
    data['restaurant_image_url'] = this._restaurantImageUrl;
    data['delivery_man_image_url'] = this._deliveryManImageUrl;
    data['chat_image_url'] = this._chatImageUrl;
    data['offer_image_url'] = this._offerUrl;
    data['branch_image_url'] = this._branchImageUrl;
    data['delivered_order_image_url'] = this._orderDeliveryImageUrl;

    return data;
  }
}
class BannerForRestaurantWebApp {
  final int id;
  final String title;
  final String description;
  final String mobileViewDescription;

  final List<String> image;
  final int status;
  final int restaurantId;
  final String bannerType;
  final int isMobileView;
  final String buttonText;
  final String buttonLink;

  BannerForRestaurantWebApp({
      this.id,
      this.title,
      this.description,
      this.image,
      this.status,
      this.restaurantId,
      this.bannerType,
      this.isMobileView,
      this.buttonText,
      this.buttonLink,
    this.mobileViewDescription
  });

  BannerForRestaurantWebApp copyWith({
    int id,
    String title,
    String description,
    String mobileViewDescription,
    List<String> image,
    int status,
    int restaurantId,
    String bannerType,
    int isMobileView,
    String buttonText,
    String buttonLink,
  }) =>
      BannerForRestaurantWebApp(
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
  factory BannerForRestaurantWebApp.fromJson(Map<String, dynamic> json) => BannerForRestaurantWebApp(
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

  Map<String, dynamic> toJson() => {
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
class RestaurantLocationCoverage {
  String _longitude;
  String _latitude;
  double _coverage;

  RestaurantLocationCoverage(
      {String longitude, String latitude, double coverage}) {
    this._longitude = longitude;
    this._latitude = latitude;
    this._coverage = coverage;
  }

  String get longitude => _longitude;
  String get latitude => _latitude;
  double get coverage => _coverage;

  RestaurantLocationCoverage.fromJson(Map<String, dynamic> json) {
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _coverage = json['coverage'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['longitude'] = this._longitude;
    data['latitude'] = this._latitude;
    data['coverage'] = this._coverage;
    return data;
  }
}

class Branches {
  int _id;
  String _name;
  String _email;
  String _longitude;
  String _latitude;
  String _address;
  double _coverage;
  String _coverImage;
  String _image;
  bool _status;

  Branches(
      {int id,
        String name,
        String email,
        String longitude,
        String latitude,
        String address,
        double coverage,
        String coverImage,
        String image,
        bool status,
      }) {
    this._id = id;
    this._name = name;
    this._email = email;
    this._longitude = longitude;
    this._latitude = latitude;
    this._address = address;
    this._coverage = coverage;
    this._coverImage = coverImage;
    this._image = image;
  }

  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get longitude => _longitude;
  String get latitude => _latitude;
  String get address => _address;
  double get coverage => _coverage;
  String get coverImage => _coverImage;
  String get image => _image;
  bool get status => _status;

  Branches.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _address = json['address'];
    _coverage = json['coverage'].toDouble();
    _image = json['image'];
    _status = json['status'];
    _coverImage = json['cover_image'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['email'] = this._email;
    data['longitude'] = this._longitude;
    data['latitude'] = this._latitude;
    data['address'] = this._address;
    data['coverage'] = this._coverage;
    data['image'] = this._image;
    data['status'] = this._status;
    return data;
  }
}
class BranchValue {
  final Branches branches;
  final double distance;

  BranchValue(this.branches, this.distance);
}
class DeliveryManagement {
  int _status;
  double _minShippingCharge;
  double _shippingPerKm;

  DeliveryManagement(
      {int status, double minShippingCharge, double shippingPerKm}) {
    this._status = status;
    this._minShippingCharge = minShippingCharge;
    this._shippingPerKm = shippingPerKm;
  }

  int get status => _status;
  double get minShippingCharge => _minShippingCharge;
  double get shippingPerKm => _shippingPerKm;

  DeliveryManagement.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _minShippingCharge = json['min_shipping_charge'].toDouble();
    _shippingPerKm = json['shipping_per_km'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['min_shipping_charge'] = this._minShippingCharge;
    data['shipping_per_km'] = this._shippingPerKm;
    return data;
  }
}
class PlayStoreConfig{
  bool _status;
  String _link;
  double _minVersion;

  PlayStoreConfig({bool status, String link, double minVersion}){
    this._status = status;
    this._link = link;
    this._minVersion = minVersion;
  }
  bool get status => _status;
  String get link => _link;
  double get minVersion =>_minVersion;

  PlayStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if(json['link'] != null){
      _link = json['link'];
    }
    if(json['min_version'] != null && json['min_version'] != '' ){
      _minVersion = double.parse(json['min_version']);
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['link'] = this._link;
    data['min_version'] = this._minVersion;

    return data;
  }
}

class AppStoreConfig{
  bool _status;
  String _link;
  double _minVersion;

  AppStoreConfig({bool status, String link, double minVersion}){
    this._status = status;
    this._link = link;
    this._minVersion = minVersion;
  }

  bool get status => _status;
  String get link => _link;
  double get minVersion =>_minVersion;


  AppStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if(json['link'] != null){
      _link = json['link'];
    }
    if(json['min_version'] !=null  && json['min_version'] != ''){
      _minVersion = double.parse(json['min_version']);
    }

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['link'] = this._link;
    data['min_version'] = this._minVersion;

    return data;
  }
}

class SocialMediaLink {
  int id;
  String name;
  String link;
  int status;
  String updatedAt;

  SocialMediaLink(
      {this.id,
        this.name,
        this.link,
        this.status,
        this.updatedAt});

  SocialMediaLink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    link = json['link'];
    status = json['status'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['link'] = this.link;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class RestaurantScheduleTime {
  RestaurantScheduleTime({
    this.day,
    this.openingTime,
    this.closingTime,
  });

  String day;
  String openingTime;
  String closingTime;

  factory RestaurantScheduleTime.fromJson(Map<String, dynamic> json) => RestaurantScheduleTime(
    day: json["day"].toString(),
    openingTime: json["opening_time"].toString(),
    closingTime: json["closing_time"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "opening_time": openingTime,
    "closing_time": closingTime,
  };
}

class SocialStatus{
  bool isGoogle;
  bool isFacebook;

  SocialStatus(this.isGoogle, this.isFacebook);

  SocialStatus.fromJson(Map<String, dynamic> json){
    isGoogle = '${json['google']}' == '1';
    isFacebook = '${json['facebook']}' == '1';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['google'] = this.isGoogle;
    data['facebook'] = this.isFacebook;
    return data;
  }
}