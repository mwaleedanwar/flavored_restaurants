import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProductShimmer extends StatelessWidget {
  final bool isEnabled;
  const ProductShimmer({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          horizontal: Dimensions.PADDING_SIZE_SMALL),
      margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.grey.shade900
                : Colors.grey.shade300,
            blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
            spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
          )
        ],
      ),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: isEnabled,
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Container(
                    height: 15,
                    width: double.maxFinite,
                    color: Colors.grey.shade300),
                const SizedBox(height: 15),
                Container(height: 10, width: 50, color: Colors.grey.shade300),
              ])),
          const SizedBox(width: 10),
          Container(
            height: 70,
            width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
        ]),
      ),
    );
  }
}
