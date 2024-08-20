import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';

class BranchButtonView extends StatelessWidget {
  final String branchName;
  const BranchButtonView({super.key, required this.branchName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
            branchName,
            style: poppinsRegular.copyWith(
              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
