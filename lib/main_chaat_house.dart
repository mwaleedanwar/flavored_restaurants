import 'flavors.dart';
import 'main_common.dart';

Future<void> main() async {
  F.appFlavor = Flavor.chaatHouse;
  await mainCommon();
}
