import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/notification_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/main.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/image_widget.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/order/order_details_screen.dart';

class NotificationPopUpDialog extends StatefulWidget {
  final PayloadModel payloadModel;
  const NotificationPopUpDialog(this.payloadModel, {super.key});

  @override
  State<NotificationPopUpDialog> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NotificationPopUpDialog> {
  @override
  void initState() {
    super.initState();

    _startAlarm();
  }

  void _startAlarm() async {
    AudioPlayer audio = AudioPlayer();
    audio.play(AssetSource('notification.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.notifications_active, size: 60, color: Theme.of(context).primaryColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Text(
              '${widget.payloadModel.title} ${widget.payloadModel.orderId != '' ? '(${widget.payloadModel.orderId})' : ''}',
              textAlign: TextAlign.center,
              style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
          ),
          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Column(
              children: [
                Text(
                  widget.payloadModel.body ?? '',
                  textAlign: TextAlign.center,
                  style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
                if (widget.payloadModel.image != 'null')
                  const SizedBox(
                    height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  ),
                if (widget.payloadModel.image != 'null')
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ImageWidget(
                      widget.payloadModel.image!,
                      height: 100,
                      width: 500,
                      placeholder: Images.placeholder_image,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Flexible(
              child: SizedBox(
                  width: 120,
                  height: 40,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT)),
                    ),
                    child: Text(
                      getTranslated('cancel', context),
                      textAlign: TextAlign.center,
                      style: poppinsRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                  )),
            ),
            const SizedBox(width: 20),
            if (widget.payloadModel.orderId != null || widget.payloadModel.type == 'message')
              Flexible(
                child: SizedBox(
                  width: 120,
                  height: 40,
                  child: CustomButton(
                    // textColor: Colors.white,
                    btnTxt: getTranslated('go', context),
                    onTap: () {
                      Navigator.pop(context);
                      debugPrint(
                          'order id : ${widget.payloadModel.orderId} && ${widget.payloadModel.orderId.runtimeType}');

                      try {
                        if (widget.payloadModel.orderId == null ||
                            widget.payloadModel.orderId == '' ||
                            widget.payloadModel.orderId == 'null') {
                          Navigator.pushNamed(context, Routes.getChatRoute(orderModel: null));
                        } else {
                          Get.navigator.push(MaterialPageRoute(
                            builder: (context) => OrderDetailsScreen(
                              orderModel: null,
                              orderId: int.tryParse(widget.payloadModel.orderId!),
                            ),
                          ));
                        }
                      } catch (e) {
                        debugPrint('ERROR NOTIF POPUP DIALOG $e');
                      }
                    },
                  ),
                ),
              ),
          ]),
        ]),
      ),
    );
  }
}
