import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/address_model.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/location_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/paymet_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/payment_card_model.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final AddressModel addressModel;
  final int index;
  const DeleteConfirmationDialog({
    super.key,
    required this.addressModel,
    required this.index,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 300,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(
              Icons.contact_support,
              size: 50,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: FittedBox(
              child: Text(getTranslated('want_to_delete', context),
                  style: rubikRegular, textAlign: TextAlign.center, maxLines: 1),
            ),
          ),
          Divider(height: 0, color: ColorResources.getHintColor(context)),
          Row(children: [
            Expanded(
                child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          ),
                        ));
                Provider.of<LocationProvider>(context, listen: false).deleteUserAddressByID(addressModel.id!, index,
                    (bool isSuccessful, String message) {
                  Navigator.pop(context);
                  showCustomSnackBar(message, context, isError: !isSuccessful);
                  Navigator.pop(context);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                alignment: Alignment.center,
                decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                child: Text(getTranslated('yes', context),
                    style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
              ),
            )),
            Expanded(
                child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10)),
                ),
                child: Text(getTranslated('no', context), style: rubikBold.copyWith(color: Colors.white)),
              ),
            )),
          ])
        ]),
      ),
    );
  }
}

class CardDeleteConfirmationDialog extends StatelessWidget {
  final PyamentCardModel paymentCardModel;
  final int index;
  const CardDeleteConfirmationDialog({
    super.key,
    required this.paymentCardModel,
    required this.index,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 300,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(
              Icons.contact_support,
              size: 50,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: FittedBox(
              child: Text(getTranslated('want_to_delete', context),
                  style: rubikRegular, textAlign: TextAlign.center, maxLines: 1),
            ),
          ),
          Divider(height: 0, color: ColorResources.getHintColor(context)),
          Row(children: [
            Expanded(
                child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          ),
                        ));
                debugPrint('===Card PaymentID: ${paymentCardModel.paymentId}');
                Provider.of<PaymentProvider>(context, listen: false)
                    .removeCard(paymentCardModel.paymentId, context)
                    .then((value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                alignment: Alignment.center,
                decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                child: Text(getTranslated('yes', context),
                    style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
              ),
            )),
            Expanded(
                child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10)),
                ),
                child: Text(getTranslated('no', context), style: rubikBold.copyWith(color: Colors.white)),
              ),
            )),
          ])
        ]),
      ),
    );
  }
}