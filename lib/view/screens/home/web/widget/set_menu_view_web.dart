import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/set_menu_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/rating_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/web/widget/arrey_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/web/widget/set_menu_page_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SetMenuViewWeb extends StatefulWidget {
  const SetMenuViewWeb({super.key});

  @override
  State<SetMenuViewWeb> createState() => _SetMenuViewWebState();
}

class _SetMenuViewWebState extends State<SetMenuViewWeb> {
  final PageController pageController = PageController();

  void _nextPage() {
    pageController.nextPage(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    pageController.previousPage(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SetMenuProvider>(
      builder: (context, setMenu, child) {
        return Column(
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(getTranslated('set_menu', context),
                          style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_OVER_LARGE)),
                    ),
                  ],
                ),
                Positioned.fill(
                    child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    ArrayButton(
                        isLeft: true,
                        isLarge: false,
                        onTop: _previousPage,
                        isVisible: !setMenu.pageFirstIndex &&
                            (setMenu.setMenuList != null ? setMenu.setMenuList!.length > 5 : false)),
                    const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    ArrayButton(
                        isLeft: false,
                        isLarge: false,
                        onTop: _nextPage,
                        isVisible: !setMenu.pageLastIndex &&
                            (setMenu.setMenuList != null ? setMenu.setMenuList!.length > 5 : false))
                  ]),
                ))
              ],
            ),
            SizedBox(
              height: 360,
              child: setMenu.setMenuList != null
                  ? setMenu.setMenuList!.isNotEmpty
                      ? SetMenuPageView(setMenuProvider: setMenu, pageController: pageController)
                      : Center(child: Text(getTranslated('no_set_menu_available', context)))
                  : const SetMenuShimmer(),
            ),
          ],
        );
      },
    );
  }
}

class SetMenuShimmer extends StatelessWidget {
  const SetMenuShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          height: 360,
          width: 280,
          margin: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10, spreadRadius: 1)]),
          child: Shimmer(
            duration: const Duration(seconds: 1),
            interval: const Duration(seconds: 1),
            enabled: Provider.of<SetMenuProvider>(context).setMenuList == null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 225.0,
                width: 368,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)), color: Colors.grey.shade300),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Container(height: 15, color: Colors.grey.shade300),
                        ),
                        const RatingBar(rating: 0.0, size: Dimensions.PADDING_SIZE_DEFAULT),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(height: Dimensions.PADDING_SIZE_SMALL, width: 30, color: Colors.grey.shade300),
                              const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Container(height: Dimensions.PADDING_SIZE_SMALL, width: 30, color: Colors.grey.shade300),
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 240,
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey.shade300),
                        ),
                        const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
