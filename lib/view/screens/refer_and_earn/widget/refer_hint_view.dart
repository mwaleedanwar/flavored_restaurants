import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/localization/language_constrants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';

class ReferHintView extends StatelessWidget {
  final List<String> hintList;
  const ReferHintView({Key key, this.hintList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2), width: 2),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.04),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            if (!ResponsiveHelper.isDesktop(context))
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                width: 30,
              ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_DEFAULT,
            ),
            Row(
              children: [
                // Image.asset(Images.i_mark, height: Dimensions.FONT_SIZE_EXTRA_LARGE,),
                SizedBox(
                  width: Dimensions.PADDING_SIZE_SMALL,
                ),

                Text(
                  'How you it works ?',
                  style: rubikBold.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).textTheme.bodyLarge.color),
                ),
              ],
            ),
            Column(
              children: hintList
                  .map(
                    (hint) => Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                          decoration:
                              BoxDecoration(color: Theme.of(context).cardColor, shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(0.05),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            )
                          ]),
                          child: Text('${hintList.indexOf(hint) + 1}',
                              style: rubikRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                              )),
                        ),
                        SizedBox(
                          width: Dimensions.PADDING_SIZE_LARGE,
                        ),
                        Expanded(
                          child: Text(
                            hint,
                            style: rubikRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: Theme.of(context).textTheme.bodyText2.color.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
