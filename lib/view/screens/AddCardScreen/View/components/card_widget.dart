import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/address/widget/delete_confirmation_dialog.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/payment_card_model.dart';

class CardWidget extends StatelessWidget {
  final PyamentCardModel paymentModel;
  final int index;
  const CardWidget({super.key, required this.paymentModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
            color: ColorResources.getSearchBg(context),
            border: Border.all(
                color: paymentModel.defaultCard == '1' ? Theme.of(context).primaryColor : Colors.transparent)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  const Icon(
                    Icons.credit_card,
                    size: 22,
                  ),
                  const SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          paymentModel.customerAccount,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(.65)),
                        ),
                        Text(
                          "${paymentModel.cardNo}****${paymentModel.cardNo}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => CardDeleteConfirmationDialog(paymentCardModel: paymentModel, index: index));
                },
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
