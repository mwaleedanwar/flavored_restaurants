import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/coupon_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/coupon_provider.dart';

class GiftDialog extends StatelessWidget {
  final CouponModel couponModel;

  const GiftDialog({super.key, required this.couponModel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 320,
        height: couponModel.discountType == 'product' ? 320 : 300,
        child: Consumer<AuthProvider>(builder: (context, auth, child) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/image/gift.gif',
                                  height: 40,
                                  width: 40,
                                ),
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'WELCOME GIFT',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                        color: Color(0xFF042448),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          couponModel.discountType == 'product'
                              ? 'Get one ${couponModel.product!.name} free'
                              : '\$${couponModel.discount} Discount',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Code : ${couponModel.code}',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Discount in Amount',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          color: Colors.black26,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: couponModel.code)).then((value) {
                            //only if ->
                            final snackBar = SnackBar(
                              content: const Text('Copied to Clipboard'),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {},
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          decoration:
                              BoxDecoration(color: const Color(0xFF042448), borderRadius: BorderRadius.circular(5)),
                          child: const Text(
                            'Copy Coupon Code',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Note: This Coupon is applicable  for your first order. Use it within next 2 days',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 11,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ]),
              ),
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        width: 10,
                        color: const Color(0xFF042448),
                      ),
                      Container(
                        width: 80,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
                      )
                    ],
                  ),
                  Positioned(
                    left: -8,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: const Color(0xFF042448),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              couponModel.discountType == 'product'
                                  ? '\$${couponModel.product!.price}'
                                  : '\$${couponModel.discount}',
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 22,
                                color: Color(0xFF042448),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'off',
                              style: TextStyle(
                                fontSize: 22,
                                color: Color(0xFF042448),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -5,
                    top: -5,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<CouponProvider>(context, listen: false).gift = null;
                      },
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}

class WelcomeMessageDialog extends StatelessWidget {
  const WelcomeMessageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 320,
        // height:  300,
        child: Consumer<AuthProvider>(builder: (context, auth, child) {
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          F.logo,
                          height: 80,
                          width: 80,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Thank you',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'For joining the club! ',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0, right: 12, top: 5),
                      child: Text(
                        'Keep any eye out for welcome message in inbox',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/image/message.gif',
                          height: 80,
                          width: 80,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
              Positioned(
                right: -5,
                top: -5,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Provider.of<AuthProvider>(context, listen: false).resetSignUp();
                  },
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
