import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/order_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/no_data_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/order/widget/order_item.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/order/widget/order_shimmer.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  final bool isRunning;
  const OrderView({super.key, required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<OrderProvider>(
        builder: (context, order, index) {
          List<OrderModel>? orderList;
          if (order.runningOrderList != null) {
            orderList =
                isRunning ? order.runningOrderList!.reversed.toList() : order.historyOrderList?.reversed.toList();
          }

          return orderList != null
              ? orderList.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: ResponsiveHelper.isDesktop(context)
                                          ? MediaQuery.of(context).size.height - 400
                                          : MediaQuery.of(context).size.height),
                                  child: SizedBox(
                                    width: 1170,
                                    child: ResponsiveHelper.isDesktop(context)
                                        ? GridView.builder(
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: Dimensions.PADDING_SIZE_DEFAULT,
                                                childAspectRatio: 3 / 1),
                                            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                            itemCount: orderList.length,
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) => OrderItem(
                                                orderProvider: order,
                                                isRunning: isRunning,
                                                orderItem: orderList![index]),
                                          )
                                        : ListView.builder(
                                            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                            itemCount: orderList.length,
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) => OrderItem(
                                                orderProvider: order,
                                                isRunning: isRunning,
                                                orderItem: orderList![index]),
                                          ),
                                  ),
                                ),
                              ),
                              if (ResponsiveHelper.isDesktop(context))
                                const Padding(
                                  padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                                  child: FooterView(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const NoDataScreen(isOrder: true)
              : const OrderShimmer();
        },
      ),
    );
  }
}
