import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newprovider/shared/app_button.dart.dart';

import '../../../../core/app_size.dart';
import '../../../../core/utils/helper_image.dart';

class ProductDetailImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTop;
  final bool  isOwner;

  const ProductDetailImage({super.key, required this.imageUrl, required this.onTop,   this.isOwner = false});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    final imageHeight = AppSize.value(
      context,
      mobile: screenHeight * 0.36,
      tablet: screenHeight * 0.50,
      desktop: screenHeight * 0.55,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: HelperImage.buildImageUrl(imageUrl),
            height: imageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: imageHeight,
              color: Colors.grey.shade100,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: imageHeight,
              color: Colors.grey.shade100,
              child: const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          if(!isOwner == false)
          Positioned(
            top: 5,
              right: 5,
              child:
              AppButton(
                size: AppButtonSize.small,
                label: 'Contact Owner',
                onPressed: onTop,
              )),
        ],
      ),
    );
  }
}
