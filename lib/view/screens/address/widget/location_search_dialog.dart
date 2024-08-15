// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/location_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

class LocationSearchDialog extends StatefulWidget {
  const LocationSearchDialog({super.key});

  @override
  State<LocationSearchDialog> createState() => _LocationSearchDialogState();
}

class _LocationSearchDialogState extends State<LocationSearchDialog> {
  int indx = 0;
  Timer? debounce;
  List<Prediction> results = [];
  Iterable<Prediction> handleSearch(String pattern) {
    if (debounce != null) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () async {
      results = await Provider.of<LocationProvider>(context, listen: false).searchLocation(context, pattern);
      if (mounted) {
        setState(() {});
      }
    });
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: 1170,
        margin: const EdgeInsets.only(top: 80, right: 10, left: 10),
        alignment: Alignment.topCenter,
        child: Autocomplete<Prediction>(
          initialValue: TextEditingValue(text: Provider.of<LocationProvider>(context, listen: false).address ?? ''),
          fieldViewBuilder: (context, controller, focus, _) {
            return TextFormField(
              focusNode: focus,
              controller: controller,
              textInputAction: TextInputAction.search,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: getTranslated('search_location', context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                ),
                hintStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                      color: Theme.of(context).disabledColor,
                    ),
                filled: true,
                suffixIcon: InkWell(
                    onTap: () {
                      controller.clear();
                    },
                    child: const Icon(Icons.close)),
                fillColor: Theme.of(context).cardColor,
              ),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: Dimensions.FONT_SIZE_LARGE,
                  ),
            );
          },
          displayStringForOption: (option) => option.description ?? '',
          onSelected: (suggestion) {
            Provider.of<LocationProvider>(context, listen: false)
                .setLocation(
                  suggestion.placeId!,
                  suggestion.description!,
                )
                .then((_) => Navigator.of(context).pop());
          },
          optionsBuilder: (pattern) => handleSearch(pattern.text),
          optionsViewBuilder: (context, onSelected, options) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () => onSelected(options.elementAt(index)),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                    margin: const EdgeInsets.only(right: 2 * Dimensions.PADDING_SIZE_SMALL),
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        const Icon(Icons.location_on),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            options.elementAt(index).description ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    debounce?.cancel();
  }
}
