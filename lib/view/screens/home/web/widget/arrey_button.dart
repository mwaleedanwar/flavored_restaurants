import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/theme_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/dimensions.dart';
import 'package:provider/provider.dart';

class ArrayButton extends StatelessWidget {
  final bool isLeft;
  final bool isLarge;
  final void Function() onTop;
  final bool isVisible;
  const ArrayButton({
    super.key,
    required this.isLeft,
    required this.isLarge,
    required this.onTop,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: isVisible ? onTop : null,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          color: isVisible ? Theme.of(context).primaryColor.withOpacity(0.7) : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.grey.shade900 : Colors.grey.shade200,
                spreadRadius: 0,
                blurRadius: 25,
                offset: const Offset(0, 4))
          ],
        ),
        child: Padding(
          padding: isLarge ? const EdgeInsets.all(8.0) : const EdgeInsets.all(4.0),
          child: isLeft
              ? Icon(Icons.chevron_left_rounded,
                  color: isVisible ? Colors.white : Colors.black, size: isLarge ? 30 : Dimensions.PADDING_SIZE_LARGE)
              : Icon(Icons.chevron_right_rounded,
                  color: isVisible ? Colors.white : Colors.black, size: isLarge ? 30 : Dimensions.PADDING_SIZE_LARGE),
        ),
      ),
    );
  }
}
