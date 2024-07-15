import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/auth_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/routes.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/menu/widget/sign_out_confirmation_dialog.dart';

class MenuItemWeb extends StatelessWidget {
  final String image;
  final String title;
  final String routeName;
  const MenuItemWeb({
    super.key,
    required this.image,
    required this.title,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    bool isLogin = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return InkWell(
      borderRadius: BorderRadius.circular(32.0),
      onTap: () {
        if (routeName == 'version') {
        } else if (routeName == 'auth') {
          isLogin
              ? showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const SignOutConfirmationDialog(),
                )
              : Navigator.pushNamed(context, Routes.getLoginRoute());
        } else {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.04), borderRadius: BorderRadius.circular(32.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 50, height: 50, color: Theme.of(context).textTheme.bodyLarge?.color),
            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            Text(title, style: robotoRegular),
          ],
        ),
      ),
    );
  }
}
