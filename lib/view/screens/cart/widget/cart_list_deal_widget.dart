import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/provider_barrel.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/image_widget.dart';
import 'package:provider/provider.dart';

class CartListDealWidget extends StatelessWidget {
  final CartProvider cart;
  const CartListDealWidget({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cart.dealsList.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.grey.shade700 : Colors.grey.shade300,
                blurRadius: 5,
                spreadRadius: 1,
              )
            ],
          ),
          child: ExpansionTile(
            textColor: Theme.of(context).primaryColor,
            iconColor: Theme.of(context).primaryColor,
            childrenPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ImageWidget(
                '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.offerUrl}/${cart.dealsList[index].dealsDataModel!.image}',
                placeholder: Images.placeholder_image,
                height: 70,
                width: 85,
                fit: BoxFit.cover,
              ),
            ),
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(cart.dealsList[index].dealsDataModel!.name,
                      style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 7),
                  Flexible(
                    child: Text(
                      PriceConverter.convertPrice(
                        context,
                        cart.dealsList[index].price,
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                  ),
                ]),
            trailing: Container(
              width: 100,
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.onSurface, borderRadius: BorderRadius.circular(5)),
              child: Row(children: [
                InkWell(
                  onTap: () {
                    Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                    if (cart.dealsList[index].quantity > 1) {
                      Provider.of<CartProvider>(context, listen: false).setQuantity(
                        isIncrement: false,
                        isCart: false,
                        isHappyHours: false,
                        isDeal: true,
                        dealCartModel: cart.dealsList[index],
                      );
                    } else {
                      Provider.of<CartProvider>(context, listen: false).removeFromCart(
                        index,
                        isCatering: false,
                        isCart: false,
                        isDeal: true,
                        isHappyHours: false,
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Icon(Icons.remove, size: 20),
                  ),
                ),
                Text(cart.dealsList[index].quantity.toString(),
                    style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                InkWell(
                  onTap: () {
                    Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                    Provider.of<CartProvider>(context, listen: false).setQuantity(
                      isIncrement: true,
                      isCart: false,
                      isHappyHours: false,
                      isDeal: true,
                      dealCartModel: cart.dealsList[index],
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Icon(Icons.add, size: 20),
                  ),
                ),
              ]),
            ),
            children: [
              for (var deal in (cart.dealsList[index].dealsDataModel?.dealItems ?? []))
                Container(
                  margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                  child: Stack(children: [
                    const Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Icon(Icons.delete, color: Colors.white, size: 50),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Provider.of<ThemeProvider>(context).darkTheme
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                            blurRadius: 5,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ImageWidget(
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${deal.image}',
                                  placeholder: Images.placeholder_image,
                                  height: 50,
                                  width: 65,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(deal.name, style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 7),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Quantity : ${deal.itemQuantity}',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                )
            ],
          ),
        );
      },
    );
  }
}
