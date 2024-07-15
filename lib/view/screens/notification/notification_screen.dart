import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/notification_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/no_data_screen.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : CustomAppBar(context: context, title: getTranslated('notification', context)),
      body: Consumer<NotificationProvider>(builder: (context, notificationProvider, child) {
        List<DateTime> dateTimeList = [];
        return (notificationProvider.notificationList ?? []).isNotEmpty
            ? RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);
                },
                backgroundColor: Theme.of(context).primaryColor,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0.0),
                          child: Center(
                            child: Container(
                              constraints: BoxConstraints(
                                  minHeight:
                                      !ResponsiveHelper.isDesktop(context) && height < 600 ? height : height - 400),
                              width: width > Dimensions.WEB_SCREEN_WIDTH ? Dimensions.WEB_SCREEN_WIDTH : width,
                              padding: width > 700 ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                              child: ListView.builder(
                                  itemCount: notificationProvider.notificationList?.length,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    DateTime originalDateTime = DateConverter.isoStringToLocalDate(
                                        notificationProvider.notificationList![index].createdAt);
                                    DateTime convertedDate =
                                        DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day);
                                    bool addTitle = false;
                                    if (!dateTimeList.contains(convertedDate)) {
                                      addTitle = true;
                                      dateTimeList.add(convertedDate);
                                    }
                                    return InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return NotificationDialog(
                                                  notificationModel: notificationProvider.notificationList![index]);
                                            });
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          addTitle
                                              ? Padding(
                                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
                                                  child: Text(DateConverter.isoStringToLocalDateOnly(
                                                      notificationProvider.notificationList![index].createdAt)),
                                                )
                                              : const SizedBox(),
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child: FadeInImage.assetNetwork(
                                                        placeholder: Images.placeholder_image,
                                                        image:
                                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.notificationImageUrl}/${notificationProvider.notificationList![index].image}',
                                                        height: 60,
                                                        width: 60,
                                                        fit: BoxFit.cover,
                                                        imageErrorBuilder: (c, b, v) => Image.asset(
                                                            Images.placeholder_image,
                                                            height: 60,
                                                            width: 60,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 24.0),
                                                    Expanded(
                                                      child: Text(
                                                        notificationProvider.notificationList![index].title,
                                                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                              fontSize: Dimensions.FONT_SIZE_LARGE,
                                                            ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    Text(
                                                      DateConverter.isoStringToLocalTimeOnly(
                                                          notificationProvider.notificationList![index].createdAt),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium
                                                          ?.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                Container(height: 1, color: ColorResources.COLOR_GREY.withOpacity(.2))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        if (ResponsiveHelper.isDesktop(context)) const FooterView(),
                      ],
                    ),
                  ),
                ),
              )
            : const NoDataScreen();
      }),
    );
  }
}
