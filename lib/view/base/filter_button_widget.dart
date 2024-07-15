import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/localization_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:provider/provider.dart';

class FilterButtonWidget extends StatelessWidget {
  final String type;
  final List<String> items;
  final bool isBorder;
  final bool isSmall;
  final Function(String value) onSelected;

  const FilterButtonWidget({
    super.key,
    required this.type,
    required this.onSelected,
    required this.items,
    this.isBorder = false,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool ltr = Provider.of<LocalizationProvider>(context).isLtr;
    bool isVegFilter = Provider.of<ProductProvider>(context).productTypeList == items;

    return Align(
        alignment: Alignment.center,
        child: Container(
          height: ResponsiveHelper.isMobile(context) ? 35 : 40,
          margin: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          decoration: isBorder
              ? null
              : BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL)),
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => onSelected(items[index]),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                  margin: isBorder
                      ? const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL)
                      : EdgeInsets.zero,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: isBorder
                        ? const BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL))
                        : BorderRadius.horizontal(
                            left: Radius.circular(
                              ltr
                                  ? index == 0 && items[index] != type
                                      ? Dimensions.RADIUS_SMALL
                                      : 0
                                  : index == items.length - 1
                                      ? Dimensions.RADIUS_SMALL
                                      : 0,
                            ),
                            right: Radius.circular(
                              ltr
                                  ? index == items.length - 1 && items[index] != type
                                      ? Dimensions.RADIUS_SMALL
                                      : 0
                                  : index == 0
                                      ? Dimensions.RADIUS_SMALL
                                      : 0,
                            ),
                          ),
                    color: items[index] == type ? Theme.of(context).primaryColor : Theme.of(context).canvasColor,
                    border: isBorder
                        ? Border.all(width: 1.3, color: Theme.of(context).primaryColor.withOpacity(0.4))
                        : null,
                  ),
                  child: Row(
                    children: [
                      items[index] != items[0] && isVegFilter
                          ? Padding(
                              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: Image.asset(
                                Images.getImageUrl(items[index]),
                              ),
                            )
                          : const SizedBox(),
                      Text(
                        getTranslated(items[index], context),
                        style: items[index] == type
                            ? robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.white)
                            : robotoRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
