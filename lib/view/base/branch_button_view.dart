import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/branch_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:provider/provider.dart';

class BranchButtonView extends StatelessWidget {
  const BranchButtonView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BranchProvider>(builder: (context, branchProvider, _) {
      return branchProvider.getBranchId != -1
          ? InkWell(
              onTap: () => Navigator.pushNamed(context, Routes.getBranchListScreen(false)),
              child: Row(
                children: [
                  Image.asset(
                    Images.branch_icon,
                    color: Colors.white,
                    height: Dimensions.PADDING_SIZE_DEFAULT,
                  ),
                  const RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.sync_alt,
                      color: Colors.white,
                      size: Dimensions.PADDING_SIZE_DEFAULT,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    branchProvider.getBranch(context)?.name ?? '',
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ))
          : const SizedBox();
    });
  }
}
