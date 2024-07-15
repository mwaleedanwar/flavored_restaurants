import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/styles.dart';

import '../../utill/dimensions.dart';

class CustomDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final void Function() onTapTrue;
  final void Function() onTapFalse;
  final String buttonTextTrue;
  final String buttonTextFalse;
  const CustomDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonTextTrue,
    required this.buttonTextFalse,
    required this.onTapFalse,
    required this.onTapTrue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 300,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(icon, size: 50, color: Colors.white),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Text(title, style: rubikRegular, textAlign: TextAlign.center),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Text(description, style: rubikRegular, textAlign: TextAlign.center),
          ),
          Container(height: 0.5, color: Theme.of(context).hintColor),
          Row(children: [
            Expanded(
                child: InkWell(
              onTap: onTapTrue,
              child: Container(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                alignment: Alignment.center,
                decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                child: Text(buttonTextTrue, style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
              ),
            )),
            Expanded(
                child: InkWell(
              onTap: onTapFalse,
              child: Container(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10)),
                ),
                child: Text(buttonTextFalse, style: rubikBold.copyWith(color: Colors.white)),
              ),
            )),
          ])
        ]),
      ),
    );
  }
}

void showAnimatedDialog(BuildContext context, Widget dialog, {bool isFlip = false, bool dismissible = true}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, animation1, animation2) => dialog,
    transitionDuration: const Duration(milliseconds: 500),
    transitionBuilder: (context, a1, a2, widget) {
      if (isFlip) {
        return Rotation3DTransition(
          alignment: Alignment.center,
          turns: Tween<double>(begin: math.pi, end: 2.0 * math.pi)
              .animate(CurvedAnimation(parent: a1, curve: const Interval(0.0, 1.0, curve: Curves.linear))),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: a1, curve: const Interval(0.5, 1.0, curve: Curves.elasticOut))),
            child: widget,
          ),
        );
      } else {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      }
    },
  );
}

class Rotation3DTransition extends AnimatedWidget {
  const Rotation3DTransition({
    super.key,
    required Animation<double> turns,
    this.alignment = Alignment.center,
    required this.child,
  }) : super(listenable: turns);

  Animation<double> get turns => listenable as Animation<double>;

  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0006)
        ..rotateY(turns.value),
      alignment: const FractionalOffset(0.5, 0.5),
      child: child,
    );
  }
}
