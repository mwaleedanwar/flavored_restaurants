import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/html_type.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/color_resources.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/custom_app_bar.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/footer_view.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/base/web_app_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_selectable_text/fwfh_selectable_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlViewerScreen extends StatelessWidget {
  final HtmlType htmlType;
  const HtmlViewerScreen({super.key, required this.htmlType});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final policyModel = Provider.of<SplashProvider>(context, listen: false).policyModel;
    String data = 'no_data_found';
    String appBarText = '';

    switch (htmlType) {
      case HtmlType.TERMS_AND_CONDITION:
        data = configModel?.termsAndConditions ?? '';
        appBarText = 'terms_and_condition';
        break;
      case HtmlType.ABOUT_US:
        data = configModel?.aboutUs ?? '';
        appBarText = 'about_us';
        break;
      case HtmlType.PRIVACY_POLICY:
        data = configModel?.privacyPolicy ?? '';
        appBarText = 'privacy_policy';
        break;
      case HtmlType.CANCELLATION_POLICY:
        data = policyModel?.cancellationPage?.content ?? '';
        appBarText = 'cancellation_policy';
        break;
      case HtmlType.REFUND_POLICY:
        data = policyModel?.refundPage?.content ?? '';
        appBarText = 'refund_policy';
        break;
      case HtmlType.RETURN_POLICY:
        data = policyModel?.returnPage?.content ?? '';
        appBarText = 'return_policy';
        break;
    }

    if (data.isNotEmpty) {
      data = data.replaceAll('href=', 'target="_blank" href=');
    }

    // String viewID = htmlType.toString();
    // if (ResponsiveHelper.isWeb()) {
    //   try {
    //     PlatformViewRegistry().registerViewFactory(viewID, (int viewId) {
    //       html.IFrameElement ife = html.IFrameElement();
    //       ife.width = '1170';
    //       ife.height = MediaQuery.of(context).size.height.toString();
    //       ife.srcdoc = data;
    //       ife.contentEditable = 'false';
    //       ife.style.border = 'none';
    //       ife.allowFullscreen = true;
    //       return ife;
    //     });
    //   } catch (e) {
    //     debugPrint('ERROR HTML VIEWER $e');
    //   }
    // }
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const WebAppBar()
          : CustomAppBar(
              title: getTranslated(appBarText, context),
              context: context,
            ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 1170,
                child: ResponsiveHelper.isDesktop(context)
                    ? Column(
                        children: [
                          Container(
                            height: 100,
                            alignment: Alignment.center,
                            child: SelectableText(
                              getTranslated(appBarText, context),
                              style: rubikBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                  color: ColorResources.getWhiteAndBlack(context)),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ConstrainedBox(
                            constraints: BoxConstraints(minHeight: height < 600 ? height : height - 400),
                            child: HtmlWidget(
                              data,
                              factoryBuilder: () => MyWidgetFactory(),
                              key: Key(htmlType.toString()),
                              onTapUrl: (String url) {
                                return launchUrl(Uri.parse(url));
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        physics: const BouncingScrollPhysics(),
                        child: HtmlWidget(
                          data,
                          key: Key(htmlType.toString()),
                          onTapUrl: (String url) {
                            return launchUrl(Uri.parse(url));
                          },
                        ),
                      ),
              ),
            ),
            if (ResponsiveHelper.isDesktop(context)) const FooterView()
          ],
        ),
      ),
    );
  }
}

class MyWidgetFactory extends WidgetFactory with SelectableTextFactory {
  @override
  SelectionChangedCallback get selectableTextOnChanged => (selection, cause) {};
}
