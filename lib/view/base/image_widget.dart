import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/images.dart';

class ImageWidget extends StatelessWidget {
  final String image;
  final String? placeholder;
  final double? height;
  final double? width;
  final BoxFit? fit;
  const ImageWidget(
    this.image, {
    super.key,
    required this.height,
    required this.width,
    this.fit,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      placeholder: (_, __) => Image.asset(
        placeholder ?? Images.placeholder_image,
        height: height,
        width: width,
        fit: fit,
      ),
      errorWidget: (_, __, error) {
        log('image error $error');
        return Image.asset(
          placeholder ?? Images.placeholder_image,
          height: height,
          width: width,
          fit: fit,
        );
      },
      height: height,
      width: width,
      fit: fit,
      fadeOutDuration: const Duration(milliseconds: 300),
      fadeOutCurve: Curves.easeOut,
      fadeInDuration: const Duration(milliseconds: 700),
      fadeInCurve: Curves.easeIn,
    );
  }
}
