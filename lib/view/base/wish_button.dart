import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/wishlist_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:provider/provider.dart';

import '../../utill/routes.dart';
import 'custom_snackbar.dart';

class WishButton extends StatelessWidget {
  final Product product;
  final EdgeInsetsGeometry edgeInset;
  const WishButton({Key key, @required this.product, this.edgeInset = EdgeInsets.zero}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WishListProvider>(builder: (context, wishList, child) {
      return InkWell(
        onTap: () {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            List<int> productIdList = [];
            productIdList.add(product.id);

            wishList.wishIdList.contains(product.id)
                ? wishList.removeFromWishList(product, context)
                : wishList.addToWishList(product, context);
          } else {
            //   showCustomSnackBar(getTranslated('now_you_are_in_guest_mode', context), context);
            Navigator.pushNamed(context, Routes.getLoginRoute());
          }
        },
        child: Padding(
          padding: edgeInset,
          child: Icon(wishList.wishIdList.contains(product.id) ? Icons.favorite : Icons.favorite_border,
              color: wishList.wishIdList.contains(product.id)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.5)),
        ),
      );
    });
  }
}
