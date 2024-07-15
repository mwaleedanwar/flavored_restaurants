import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/category_product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/product_type.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/category_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/product_shimmer.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/product_widget.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/web/widget/product_widget_web.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/title_widget.dart';
import 'package:provider/provider.dart';

class ProductView extends StatefulWidget {
  final ProductType productType;

  final bool isFromCart;
  final bool isFromCartSheet;
  final bool isBuffet;
  final bool isFromPointsScreen;

  const ProductView({
    super.key,
    required this.productType,
    this.isFromCart = false,
    this.isBuffet = false,
    this.isFromPointsScreen = false,
    this.isFromCartSheet = false,
  });

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final ScrollController scrollController = ScrollController();
  bool isShowArrow = true;
  final double _width = 50.0;
  final int baseScrollPoint = 3;
  double scrollWidth = 0.0;
  int move = 1;
  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (isTop) {
          isShowArrow = true;
          setState(() {});
        } else {
          setState(() {
            isShowArrow = false;
          });
        }
      }
    });
  }

  scrollToRight() {
    if (scrollWidth <= scrollController.offset) {
      setState(() {
        scrollWidth = _width * baseScrollPoint * move;
        move++;
      });
      scrollController.animateTo(scrollWidth,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn);
    }
  }

  scrollToLeft() {
    if (scrollWidth > 0) {
      setState(() {
        move--;
        scrollWidth = scrollWidth - (baseScrollPoint * _width);
      });
      scrollController.animateTo(scrollWidth,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product>? productList;
        if (widget.productType == ProductType.LATEST_PRODUCT) {
          productList = prodProvider.latestProductList;
        } else if (widget.productType == ProductType.POPULAR_PRODUCT) {
          productList = prodProvider.popularProductList;
        } else if (widget.productType == ProductType.RELATED_PRODUCT) {
          productList = prodProvider.relatedProducts;
        } else if (widget.productType == ProductType.LOYALTY_PRODUCT) {
          productList = prodProvider.loyaltyPointsProducts;
        } else if (widget.productType == ProductType.RECOMMENDED_SIDES) {
          productList = prodProvider.recommendedSidesList;
        } else if (widget.productType == ProductType.RECOMMENDED_BEVERAGES) {
          productList = prodProvider.recommendedBeveragesList.reversed.toList();
        }
        if (productList == null) {
          return widget.productType == ProductType.POPULAR_PRODUCT ||
                  widget.productType == ProductType.RELATED_PRODUCT ||
                  widget.productType == ProductType.LOYALTY_PRODUCT ||
                  widget.productType == ProductType.RECOMMENDED_SIDES ||
                  widget.productType == ProductType.RECOMMENDED_BEVERAGES
              ? widget.isFromCart
                  ? SizedBox(
                      height: widget.isFromCart ? 200 : 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            width: widget.isFromCart ? 120 : 195,
                            child: ProductWidgetWebShimmer(
                              isFromCart: widget.isFromCart,
                            ),
                          );
                        },
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing:
                            ResponsiveHelper.isMobile(context) ? 8 : 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: ResponsiveHelper.isMobile(context)
                            ? widget.isFromPointsScreen
                                ? 1.8
                                : 2.1
                            : 4,
                        crossAxisCount: ResponsiveHelper.isTab(context) ? 1 : 1,
                      ),
                      itemCount: 12,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductShimmer(isEnabled: productList == null);
                      },
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL),
                    )
              : const SizedBox();
        }

        return widget.productType == ProductType.POPULAR_PRODUCT ||
                widget.productType == ProductType.RELATED_PRODUCT ||
                widget.productType == ProductType.LOYALTY_PRODUCT ||
                widget.productType == ProductType.RECOMMENDED_SIDES ||
                widget.productType == ProductType.RECOMMENDED_BEVERAGES
            ? widget.isFromCart
                ? Row(
                    children: [
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              height: widget.isFromCart ? 200 : 220,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                controller: scrollController,
                                itemCount: widget.isFromCart
                                    ? productList.length
                                    : productList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                        left: widget.isFromCart && index == 0
                                            ? 0
                                            : 10,
                                        right: 5,
                                        top: 5,
                                        bottom: 5),
                                    width: widget.isFromCart ? null : 195,
                                    child: ProductWidgetWeb(
                                      product: productList![index],
                                      fromPopularItem: true,
                                      isFromCart: widget.isFromCart,
                                      index: index,
                                      isFromCartSheet: widget.isFromCartSheet,
                                    ),
                                  );
                                },
                              ),
                            ),
                            ResponsiveHelper.isMobile(context) && isShowArrow
                                ? Positioned(
                                    top: 90,
                                    right: -5,
                                    child: InkWell(
                                      onTap: () async {
                                        scrollToRight();
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.4)),
                                          child: const Icon(
                                              Icons.arrow_forward_ios_sharp)),
                                    ))
                                : const SizedBox(),
                            ResponsiveHelper.isMobile(context) && !isShowArrow
                                ? Positioned(
                                    top: 90,
                                    left: -5,
                                    child: InkWell(
                                      onTap: () {
                                        scrollToLeft();
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.4)),
                                          child:
                                              const Icon(Icons.arrow_back_ios)),
                                    ))
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ],
                  )
                : widget.isBuffet
                    ? SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.isFromCart
                              ? productList.length
                              : productList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 5, top: 5, bottom: 5),
                              width: 195,
                              child: ProductWidgetWeb(
                                product: productList![index],
                                fromPopularItem: true,
                                isFromCart: widget.isFromCart,
                                index: index,
                                isFromCartSheet: widget.isFromCartSheet,
                              ),
                            );
                          },
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing:
                              ResponsiveHelper.isMobile(context) ? 8 : 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: ResponsiveHelper.isMobile(context)
                              ? widget.isFromPointsScreen
                                  ? 1.8
                                  : 2.1
                              : 4,
                          crossAxisCount:
                              ResponsiveHelper.isTab(context) ? 1 : 1,
                        ),
                        itemCount: productList.length,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ProductWidget(
                            product: productList![index],
                            isFromPoinst: widget.isFromPointsScreen,
                          );
                        },
                      )
            : Column(children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing:
                        ResponsiveHelper.isMobile(context) ? 8 : 5,
                    mainAxisSpacing: 5,
                    childAspectRatio:
                        ResponsiveHelper.isMobile(context) ? 2.1 : 4,
                    crossAxisCount: ResponsiveHelper.isTab(context) ? 2 : 2,
                  ),
                  itemCount: productList.length,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductWidget(
                      product: productList![index],
                    );
                  },
                ),
                const SizedBox(height: 30),
                productList.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(0),
                        child: prodProvider.isLoading
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                )),
                              ))
                            : const SizedBox.shrink(),
                      )
                    : const SizedBox.shrink(),
              ]);
      },
    );
  }
}

class ProducCatView extends StatefulWidget {
  final ProductType productType;
  final bool isFromCart;
  final bool isFromCartSheet;

  const ProducCatView({
    super.key,
    required this.productType,
    this.isFromCart = false,
    this.isFromCartSheet = false,
  });

  @override
  State<ProducCatView> createState() => _ProducCatViewState();
}

class _ProducCatViewState extends State<ProducCatView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AllCategoryProvider>(
      builder: (context, prodProvider, child) {
        List<CategoryProductModel> productList;

        productList = prodProvider.categoryList;

        if (productList.isEmpty) {
          return const SizedBox();
        }

        return ListView.builder(
            itemCount: productList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, ind) {
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 6),
                  child: TitleWidget(title: productList[ind].name),
                ),

                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing:
                        ResponsiveHelper.isMobile(context) ? 8 : 5,
                    mainAxisSpacing: 5,
                    childAspectRatio:
                        ResponsiveHelper.isMobile(context) ? 2.1 : 4,
                    crossAxisCount: ResponsiveHelper.isTab(context) ? 1 : 1,
                  ),
                  itemCount: productList[ind].products.length,
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductWidget(
                      product: productList[ind].products[index],
                    );
                  },
                ),
                // SizedBox(height: 30),

                productList.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(0),
                        child: prodProvider.isLoading
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                )),
                              ))
                            : const SizedBox.shrink(),
                      )
                    : const SizedBox.shrink(),
              ]);
            });
      },
    );
  }
}
