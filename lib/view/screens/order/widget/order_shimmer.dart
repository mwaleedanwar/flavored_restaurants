import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OrderShimmer extends StatelessWidget {
  const OrderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Center(
          child: Container(
            width: 1170,
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.grey.shade700 : Colors.grey.shade300,
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: Provider.of<OrderProvider>(context).runningOrderList == null,
              child: Column(children: [
                Row(children: [
                  Container(
                    height: 70,
                    width: 80,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.shade300),
                  ),
                  const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(height: 15, width: 150, color: Colors.grey.shade300),
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Container(height: 15, width: 100, color: Colors.grey.shade300),
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Container(height: 15, width: 130, color: Colors.grey.shade300),
                  ]),
                ]),
                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                Row(children: [
                  Expanded(
                      child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
                  const SizedBox(width: 20),
                  Expanded(
                      child: Container(
                    height: 50,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                  )),
                ]),
              ]),
            ),
          ),
        );
      },
    );
  }
}
