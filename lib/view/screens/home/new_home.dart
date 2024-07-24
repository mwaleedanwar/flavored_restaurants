import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/category_product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/product_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/price_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/category_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/product_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/cart_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_button.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/product_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(context: context, title: 'Food Menu', isBackButtonExist: false),
        body: Consumer<AllCategoryProvider>(builder: (context, category, child) {
          Provider.of<CartProvider>(context).setFalse();

          return category.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ))
              : ScrollableListTabView(
                  tabHeight: 48,
                  bodyAnimationDuration: const Duration(milliseconds: 150),
                  tabAnimationCurve: Curves.easeOut,
                  tabAnimationDuration: const Duration(milliseconds: 200),
                  tabs: List.generate(
                    category.categoryList.length,
                    (index) => ScrollableListTab(
                      tab: ListTab(
                          borderColor: Colors.transparent,
                          activeBackgroundColor: Theme.of(context).primaryColor,
                          label: Text(category.categoryList[index].name),
                          // icon: Icon(Icons.group),
                          showIconOnList: false),
                      body: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: ResponsiveHelper.isMobile(context) ? 8 : 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: ResponsiveHelper.isMobile(context) ? 2.1 : 4.5,
                          crossAxisCount: ResponsiveHelper.isTab(context) ? 1 : 1,
                        ),
                        itemCount: category.categoryList[index].products.length,
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int ind) {
                          return ProductWidget(
                            product: category.categoryList[index].products[ind],
                          );
                        },
                      ),
                    ),
                  ),
                );
        }),
        bottomNavigationBar: Consumer<CartProvider>(builder: (context, cart, child) {
          return cart.isFromCategory == true
              ? Container(
                  width: 1170,
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: CustomButton(
                      btnTxt: 'View in cart',
                      onTap: () {
                        Navigator.pushNamed(context, Routes.getDashboardRoute('cart'));
                      }),
                )
              : const SizedBox.shrink();
        }));
  }
}

class TestMenuScreen extends StatefulWidget {
  const TestMenuScreen({super.key});

  @override
  State<TestMenuScreen> createState() => _TestMenuScreenState();
}

class _TestMenuScreenState extends State<TestMenuScreen> with TickerProviderStateMixin {
  late TabController _categoryTabController;
  final _tabInfoList = <GlobalKey>[];
  bool loading = true;
  void _initTabList() {
    final categories = Provider.of<AllCategoryProvider>(context).categoryList;
    for (int i = 0; i < categories.length; i++) {
      _tabInfoList.add(GlobalKey());
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    VisibilityDetectorController.instance.notifyNow();
  }

  double maxLength(List<CategoryProductModel> categories) {
    double max = 0;
    for (CategoryProductModel category in categories) {
      if (category.name.length > max) {
        max = category.name.length.toDouble();
      }
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AllCategoryProvider>(
      builder: (context, provider, _) {
        if (_tabInfoList.isEmpty) {
          _initTabList();
          _categoryTabController = TabController(initialIndex: 0, length: _tabInfoList.length, vsync: this);
          final productProvider = Provider.of<ProductProvider>(context, listen: false);
          if (productProvider.popularProductList == null) {
            productProvider.getPopularProductList(
              context,
              false,
              '1',
            );
          }
          loading = false;
        }
        return loading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Scaffold(
                appBar: CustomAppBar(context: context, title: 'Food Menu', isBackButtonExist: false),
                body: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverPersistentHeader(
                      delegate: _CategoryTabBarDelegate(
                        _categoryTabController,
                        provider.categoryList,
                        _tabInfoList,
                        maxLength(provider.categoryList) > 12 ? 110 : 90,
                      ),
                      pinned: true,
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'Popular Items',
                          style: rubikMedium.copyWith(
                            fontSize: ResponsiveHelper.isTab(context)
                                ? Dimensions.FONT_SIZE_OVER_LARGE
                                : Dimensions.FONT_SIZE_LARGE,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 15),
                      sliver: SliverToBoxAdapter(
                        child: SizedBox(
                          height: ResponsiveHelper.isTab(context) ? 300 : 200,
                          width: MediaQuery.of(context).size.width,
                          child: PopularProductCarousel(
                            products: Provider.of<ProductProvider>(context).popularProductList,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      sliver: SliverToBoxAdapter(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              provider.categoryList.length,
                              (index) => VisibilityDetector(
                                key: _tabInfoList[index],
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      provider.categoryList[index].name,
                                      style: rubikMedium.copyWith(
                                        fontSize: ResponsiveHelper.isTab(context)
                                            ? Dimensions.FONT_SIZE_OVER_LARGE
                                            : Dimensions.FONT_SIZE_LARGE,
                                      ),
                                    ),
                                    ...List.generate(
                                        provider.categoryList[index].products.length,
                                        (i) => Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 7.5),
                                              child: ProductWidget(product: provider.categoryList[index].products[i]),
                                            ))
                                  ],
                                ),
                                onVisibilityChanged: (VisibilityInfo info) {
                                  double screenHeight = MediaQuery.of(context).size.height;
                                  double visibleAreaOnScreen = info.visibleBounds.bottom - info.visibleBounds.top;
                                  if (info.visibleFraction > 0.5 || visibleAreaOnScreen > screenHeight * 0.5) {
                                    _categoryTabController.animateTo(index);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}

class _CategoryTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController controller;
  final List<CategoryProductModel> data;
  List<GlobalKey> keys;
  double size;
  _CategoryTabBarDelegate(
    this.controller,
    this.data,
    this.keys,
    this.size,
  );

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: CategoryTabBar(
        controller: controller,
        data: data,
        keys: keys,
      ),
    );
  }

  @override
  double get maxExtent => size;

  @override
  double get minExtent => size;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class CategoryTabBar extends StatefulWidget {
  final TabController controller;
  final List<CategoryProductModel> data;
  final List<GlobalKey> keys;
  const CategoryTabBar({
    super.key,
    required this.controller,
    required this.data,
    required this.keys,
  });

  @override
  State<CategoryTabBar> createState() => _CategoryTabBarState();
}

class _CategoryTabBarState extends State<CategoryTabBar> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TabBar(
        indicatorPadding: EdgeInsets.zero,
        indicatorColor: F.appbarHeaderColor,
        controller: widget.controller,
        isScrollable: true,
        labelPadding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        tabAlignment: TabAlignment.start,
        onTap: (index) async {
          currentIndex = index;
          GlobalKey globalKey = widget.keys[index];
          await Scrollable.ensureVisible(
            globalKey.currentContext!,
            duration: const Duration(milliseconds: 150),
          );
          setState(() {});
        },
        tabs: List.generate(widget.data.length, (index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ClipOval(
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder_image,
                    width: currentIndex == index ? 70 : 65,
                    height: currentIndex == index ? 70 : 65,
                    fit: BoxFit.cover,
                    image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                        ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${widget.data[index].image}'
                        : '',
                    imageErrorBuilder: (c, o, s) =>
                        Image.asset(Images.placeholder_image, width: 65, height: 65, fit: BoxFit.cover),
                  ),
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 80),
                child: Text(
                  widget.data[index].name,
                  style: rubikMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_SMALL,
                    fontWeight: currentIndex != index ? FontWeight.w500 : FontWeight.w700,
                    color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class PopularProductCarousel extends StatefulWidget {
  final List<Product>? products;
  const PopularProductCarousel({super.key, this.products});

  @override
  State<PopularProductCarousel> createState() => _PopularProductCarouselState();
}

class _PopularProductCarouselState extends State<PopularProductCarousel> {
  final controller = CarouselController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.products != null
          ? Center(
              child: CarouselSlider(
                carouselController: controller,
                items: List.generate(
                  widget.products!.length,
                  (index) => PopularProductCard(
                    product: widget.products![index],
                    rank: index,
                  ),
                ),
                options: CarouselOptions(
                  viewportFraction: 0.5,
                  padEnds: true,
                  aspectRatio: ResponsiveHelper.isTab(context)
                      ? 3
                      : 1.05 * MediaQuery.of(context).size.height / MediaQuery.of(context).size.width,
                ),
              ),
            )
          : const SizedBox.shrink(),
      Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_circle_left_outlined,
            color: Colors.white,
            size: 35,
            shadows: [Shadow(color: Colors.black, blurRadius: 7.5)],
          ),
          onPressed: () => controller.previousPage(),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_circle_right_outlined,
            color: Colors.white,
            size: 35,
            shadows: [Shadow(color: Colors.black, blurRadius: 7.5)],
          ),
          onPressed: () => controller.nextPage(),
        ),
      ),
    ]);
  }
}

class PopularProductCard extends StatelessWidget {
  final int rank;
  final Product product;

  const PopularProductCard({
    super.key,
    required this.product,
    required this.rank,
  });

  TextStyle get style => const TextStyle(
        color: Colors.white,
        shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 7.5)],
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (con) => CartBottomSheet(
            product: product,
            cart: null,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholder_rectangle,
                  image:
                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image}',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: ResponsiveHelper.isTab(context) ? 350 : 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('#${rank + 1} Popular Item',
                      style: style.copyWith(
                          fontSize: ResponsiveHelper.isTab(context) ? Dimensions.FONT_SIZE_EXTRA_LARGE : null)),
                  Text(product.name,
                      style: style.copyWith(
                          fontSize: ResponsiveHelper.isTab(context) ? Dimensions.FONT_SIZE_EXTRA_LARGE : null)),
                  Row(
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black)],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(PriceConverter.convertPrice(context, product.price),
                          style: style.copyWith(
                              fontSize: ResponsiveHelper.isTab(context) ? Dimensions.FONT_SIZE_EXTRA_LARGE : null)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
