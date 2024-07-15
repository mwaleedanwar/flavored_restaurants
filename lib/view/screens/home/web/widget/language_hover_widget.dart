import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/language_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/language_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/category_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/localization_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_snackbar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/on_hover.dart';
import 'package:provider/provider.dart';

class LanguageHoverWidget extends StatefulWidget {
  final List<LanguageModel> languageList;
  const LanguageHoverWidget({super.key, required this.languageList});

  @override
  State<LanguageHoverWidget> createState() => _LanguageHoverWidgetState();
}

class _LanguageHoverWidgetState extends State<LanguageHoverWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context, languageProvider, child) {
      return Container(
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        child: Column(
            children: widget.languageList
                .map((language) => InkWell(
                      onTap: () async {
                        if (languageProvider.languages.isNotEmpty && languageProvider.selectIndex != -1) {
                          Provider.of<ProductProvider>(context, listen: false).latestOffset = 1;
                          Provider.of<ProductProvider>(context, listen: false).popularOffset = 1;
                          Provider.of<LocalizationProvider>(context, listen: false)
                              .setLanguage(Locale(language.languageCode, language.countryCode));

                          Provider.of<ProductProvider>(context, listen: false).getLatestProductList(
                            context,
                            false,
                            '1',
                            AppConstants.languages[languageProvider.selectIndex].languageCode,
                          );

                          Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
                            context,
                            true,
                            '1',
                          );

                          Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
                            context,
                            true,
                            AppConstants.languages[languageProvider.selectIndex].languageCode,
                          );
                        } else {
                          showCustomSnackBar(getTranslated('select_a_language', context), context);
                        }
                      },
                      child: OnHover(builder: (isHover) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                              horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                          decoration: BoxDecoration(
                              color:
                                  isHover ? ColorResources.getCategoryHoverColor(context) : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                    child: Image.asset(
                                      language.imageUrl,
                                      height: Dimensions.PADDING_SIZE_LARGE,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(
                                    language.languageName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: Dimensions.FONT_SIZE_SMALL),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ))
                .toList()),
      );
    });
  }
}
