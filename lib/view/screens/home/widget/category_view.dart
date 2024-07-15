import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/category_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  ScrollController scrollController = ScrollController();
  bool isShowArrow = true;
  final double _width = 50.0;
  final listLength = 20;
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
          debugPrint('At the top');
          isShowArrow = true;
          setState(() {});
        } else {
          setState(() {
            isShowArrow = false;
          });
          debugPrint('At the bottom:$isShowArrow');
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
      scrollController.animateTo(scrollWidth, duration: const Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    }
  }

  scrollToLeft() {
    if (scrollWidth > 0) {
      setState(() {
        move--;
        scrollWidth = scrollWidth - (baseScrollPoint * _width);
      });
      scrollController.animateTo(scrollWidth, duration: const Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: 80,
                        child: category.categoryList.isNotEmpty
                            ? NotificationListener<ScrollEndNotification>(
                                onNotification: (scrollEnd) {
                                  final metrics = scrollEnd.metrics;
                                  if (metrics.atEdge) {
                                    bool isTop = metrics.pixels == 0;
                                    if (isTop) {
                                      setState(() {
                                        isShowArrow = true;
                                      });
                                    } else {
                                      setState(() {
                                        isShowArrow = false;
                                      });
                                    }
                                  }
                                  return true;
                                },
                                child: ListView.builder(
                                  itemCount: category.categoryList.length,
                                  padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                  physics: const BouncingScrollPhysics(),
                                  controller: scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    String name = '';
                                    category.categoryList[index].name.length > 15
                                        ? name = '${category.categoryList[index].name.substring(0, 15)} ...'
                                        : name = category.categoryList[index].name;
                                    return Padding(
                                      padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                      child: InkWell(
                                        onTap: () {
                                          //  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: 'Categories',)));

                                          Navigator.pushNamed(
                                            context,
                                            Routes.getCategoryRoute(index),
                                          );
                                        },
                                        child: Column(children: [
                                          ClipOval(
                                            child: FadeInImage.assetNetwork(
                                              placeholder: Images.placeholder_image,
                                              width: 65,
                                              height: 65,
                                              fit: BoxFit.cover,
                                              image: Provider.of<SplashProvider>(context, listen: false).baseUrls !=
                                                      null
                                                  ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${category.categoryList[index].image}'
                                                  : '',
                                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image,
                                                  width: 65, height: 65, fit: BoxFit.cover),
                                              // width: 100, height: 100, fit: BoxFit.cover,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              name,
                                              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ]),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(child: Text(getTranslated('no_category_available', context))),
                      ),
                      ResponsiveHelper.isMobile(context) && isShowArrow
                          ? Positioned(
                              top: 20,
                              right: -5,
                              child: InkWell(
                                onTap: () async {
                                  scrollToRight();
                                },
                                child: Container(
                                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
                                    child: const Icon(Icons.arrow_forward_ios_sharp)),
                              ))
                          : const SizedBox(),
                      ResponsiveHelper.isMobile(context) && !isShowArrow
                          ? Positioned(
                              top: 20,
                              left: -5,
                              child: InkWell(
                                onTap: () {
                                  scrollToLeft();
                                },
                                child: Container(
                                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
                                    child: const Icon(Icons.arrow_back_ios)),
                              ))
                          : const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: 14,
        padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: Provider.of<CategoryProvider>(context).categoryList.isNotEmpty,
              child: Column(children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 5),
                Container(height: 10, width: 50, color: Colors.grey.shade300),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  const CategoryAllShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        child: Shimmer(
          duration: const Duration(seconds: 2),
          enabled: Provider.of<CategoryProvider>(context).categoryList.isNotEmpty,
          child: Column(children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey.shade300),
          ]),
        ),
      ),
    );
  }
}
