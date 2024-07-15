import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/dio/dio_client.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/onboarding_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';

class OnBoardingRepo {
  final HttpClient httpClient;

  OnBoardingRepo({required this.httpClient});

  List<OnBoardingModel> getOnBoardingList() {
    return <OnBoardingModel>[
      OnBoardingModel(
        Images.onboarding_one,
        'Priority Home Delivery or Takeaway',
        'Order directly from our app to save money in fees, get faster service, earn free food via our rewards program, and support local business.',
      ),
      OnBoardingModel(
        Images.onboarding_two,
        'Enjoy Free Appetizer after signup',
        'Join our exclusive hearts reward program, win \$500! Be entered in a drawing to win on the 1st of next month.',
      ),
    ];
  }
}
