import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/category_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/splash_provider.dart';
import '../../../../../utill/color_resources.dart';
import '../../../../../utill/dimensions.dart';
import '../../../../../utill/images.dart';
import '../../../../../utill/styles.dart';
import '../../../../base/on_hover.dart';
import '../../new_home.dart';

class CategoryPageView extends StatelessWidget {
  final CategoryProvider categoryProvider;
  final PageController pageController;
  const CategoryPageView({
    super.key,
    required this.categoryProvider,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    int totalPage = (categoryProvider.categoryList.length / 7).ceil();

    return PageView.builder(
      controller: pageController,
      itemCount: totalPage,
      onPageChanged: (index) {
        categoryProvider.updateProductCurrentIndex(index, totalPage);
      },
      itemBuilder: (context, index) {
        int initialLength = 7;
        int currentIndex = 7 * index;
        (index + 1 == totalPage)
            ? initialLength = categoryProvider.categoryList.length - (index * 7)
            : 7;
        return ListView.builder(
            itemCount: initialLength,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, item) {
              int currentIndex0 = item + currentIndex;
              String name = '';
              categoryProvider.categoryList[currentIndex0].name.length > 15
                  ? name =
                      '${categoryProvider.categoryList[currentIndex0].name.substring(0, 15)}...'
                  : name = categoryProvider.categoryList[currentIndex0].name;
              debugPrint(
                  '=====image url: ${'${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${categoryProvider.categoryList[currentIndex0].image}'}');

              return OnHover(builder: (isHover) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () {
                      debugPrint('==cat tap');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage()));

                      // Navigator.pushNamed(
                      //   context, Routes.getCategoryRoute(categoryProvider.categoryList[_currentIndex]),
                      // );
                    }, // arguments:  category.categoryList[index].name),
                    child: Column(children: [
                      ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder_image, width: 125,
                          height: 125, fit: BoxFit.cover,
                          image: Provider.of<SplashProvider>(context,
                                          listen: false)
                                      .baseUrls !=
                                  null
                              ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${categoryProvider.categoryList[currentIndex0].image}'
                              : '',
                          imageErrorBuilder: (c, o, s) => Image.asset(
                              Images.placeholder_image,
                              width: 125,
                              height: 125,
                              fit: BoxFit.cover),
                          // width: 100, height: 100, fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: Dimensions.PADDING_SIZE_DEFAULT),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FittedBox(
                            child: Text(name,
                                style: rubikMedium.copyWith(
                                    color: isHover
                                        ? Theme.of(context).primaryColor
                                        : ColorResources.getWhiteAndBlack(
                                            context)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              });
            });
      },
    );
  }
}
