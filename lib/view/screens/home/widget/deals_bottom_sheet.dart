import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/cart_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/deals_data_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/image_widget.dart';
import 'package:provider/provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_toast.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';

class DealsBottomSheet extends StatelessWidget {
  final DealsDataModel dealsDataModel;

  const DealsBottomSheet({super.key, required this.dealsDataModel});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      cartProvider.setCartUpdate(false);
      int cartIndex = cartProvider.getCarDealIndex(dealsDataModel) ?? -1;
      return Stack(
        children: [
          Container(
            width: 600,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: ResponsiveHelper.isMobile(context)
                  ? const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  : const BorderRadius.all(Radius.circular(20)),
            ),
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveHelper.isMobile(context)
                        ? Center(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10, top: 10),
                              height: 5,
                              width: 80,
                              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                            ),
                          )
                        : const SizedBox(),
                    Text(dealsDataModel.name, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'Deal Ends At:',
                          style:
                              rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          DateConverter.estimatedDate(dealsDataModel.expireDate),
                          style:
                              rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'Discount:',
                          style:
                              rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          '${dealsDataModel.discountPercentage}%',
                          style:
                              rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          'Total price:',
                          style:
                              rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          dealsDataModel.totalDiscountAmount,
                          style:
                              rubikMedium.copyWith(fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text('Deal Items', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                    SizedBox(
                      height: 185,
                      child: ListView.builder(
                          itemCount: dealsDataModel.dealItems.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              // height: 180 ,
                              margin: EdgeInsets.only(top: 8.0, left: index == 0 ? 0 : 8, right: 6, bottom: 8),
                              width: 100,
                              decoration: BoxDecoration(
                                  color: ColorResources.getCartColor(context),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Provider.of<ThemeProvider>(context).darkTheme
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade300,
                                        blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                                        spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1)
                                  ]),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                      child: ImageWidget(
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${dealsDataModel.dealItems[index].image}',
                                        placeholder: Images.placeholder_rectangle,
                                        fit: BoxFit.cover,
                                        height: 90,
                                        width: 150,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                dealsDataModel.dealItems[index].name,
                                                style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                                maxLines: 2,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Quantity : ${dealsDataModel.dealItems[index].itemQuantity}',
                                                style: rubikBold.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_SMALL, fontWeight: FontWeight.w500),
                                              ),
                                            ]),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    )
                                  ]),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomButton(
                        btnTxt: 'Add to cart',
                        backgroundColor: Theme.of(context).primaryColor,
                        onTap: () {
                          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                            DealCartModel dealModle = DealCartModel(
                                price: double.parse(dealsDataModel.totalDiscountAmount),
                                discountedPrice: 0.0,
                                discountAmount: 0.0,
                                quantity: 1,
                                dealsDataModel: dealsDataModel);

                            if (!cartProvider.dealsList.map((e) => e.dealsDataModel!.id).contains(dealsDataModel.id)) {
                              cartProvider.addDealToCart(dealModle, cartIndex);
                              Navigator.pop(context);

                              appToast(text: 'Deal added to cart', toastColor: Colors.green);
                            } else {
                              Provider.of<CartProvider>(context, listen: false).setQuantity(
                                isIncrement: true,
                                isCatering: false,
                                isCart: false,
                                isDeal: true,
                                dealCartModel: cartProvider.dealsList
                                    .where((element) => element.dealsDataModel?.id == dealsDataModel.id)
                                    .toList()[0],
                              );
                              Navigator.pop(context);

                              appToast(
                                  text:
                                      'Deal added ${cartProvider.dealsList.where((element) => element.dealsDataModel?.id == dealsDataModel.id).toList().first.quantity} times',
                                  toastColor: Colors.green);
                            }
                          } else {
                            Navigator.pushNamed(context, Routes.getLoginRoute());
                          }
                        }),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                );
              },
            ),
          ),
          ResponsiveHelper.isMobile(context)
              ? const SizedBox()
              : Positioned(
                  right: 10,
                  top: 5,
                  child: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.close)),
                ),
        ],
      );
    });
  }
}
