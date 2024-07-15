import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/branch_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:provider/provider.dart';

class BranchButtonView extends StatelessWidget {
  final bool isRow;
  const BranchButtonView({
    super.key,
    this.isRow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BranchProvider>(builder: (context, branchProvider, _) {
      debugPrint('===isRow :$isRow');
      return branchProvider.getBranchId() != -1
          ? InkWell(
              onTap: () => Navigator.pushNamed(context, Routes.getBranchListScreen()),
              child: isRow
                  ? Row(children: [
                      Row(children: [
                        Image.asset(
                          Images.branch_icon,
                          color: Colors.white,
                          height: Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        const RotatedBox(
                            quarterTurns: 1,
                            child: Icon(Icons.sync_alt, color: Colors.white, size: Dimensions.PADDING_SIZE_DEFAULT)),
                        const SizedBox(width: 2),
                        Text(
                          branchProvider.getBranch(context)?.name ?? '',
                          style:
                              poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]),
                    ])
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(children: [
                          Image.asset(
                            Images.branch_icon,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            height: Dimensions.PADDING_SIZE_DEFAULT,
                          ),
                          RotatedBox(
                              quarterTurns: 1,
                              child: Icon(Icons.sync_alt,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                  size: Dimensions.PADDING_SIZE_DEFAULT))
                        ]),
                        const SizedBox(height: 2),
                        Text(
                          branchProvider.getBranch(context)?.name ?? '',
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ))
          : const SizedBox();
    });
  }
}
