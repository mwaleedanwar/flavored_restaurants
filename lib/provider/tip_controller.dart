import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TipController extends GetxController {
  List tipsAmountList = ['1', '2', '3', 'Other'].obs;
  List tipPercentList = ['10', '15', '20', 'Other'].obs;
  List selectedTip = [].obs;
  final TextEditingController controller = TextEditingController();
  var tip = 0.0.obs;
  var isNotTip = false.obs;

  void initialData(isFromCart, {required double orderAmount}) {
    selectedTip.clear();
    tip.value = 0.0;
    if (isFromCart) {
      selectedTip.add('15');

      double temp = (double.parse(selectedTip[0].toString()) / 100) * orderAmount;
      debugPrint('===init tip:$temp');
      tip.value = temp;
    } else {
      selectedTip.add('2');
      tip.value = double.parse(selectedTip[0].toString());
    }
  }

  void updateTip(int index, isPercent, {required double orderAmount}) {
    selectedTip.clear();
    if (isPercent) {
      selectedTip.add(tipPercentList[index]);

      if (index != 3) {
        double temp = (double.parse(selectedTip[0].toString()) / 100) * orderAmount;
        tip.value = temp;
      } else {
        tip.value = 0.0;
      }
    } else {
      selectedTip.add(tipsAmountList[index]);

      if (index != 3) {
        tip.value = double.parse(selectedTip[0].toString());
      } else {
        tip.value = 0.0;
      }
    }

    update();
  }
}
