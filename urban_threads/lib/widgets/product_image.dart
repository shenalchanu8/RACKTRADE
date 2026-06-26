import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  String get _assetPath {
    if (imageUrl.startsWith('lib/assets/')) {
      return imageUrl;
    }
    if (imageUrl.startsWith('assets/')) {
      return imageUrl;
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final child = imageUrl.trim().isEmpty
        ? const _ProductImageFallback()
        : Image.asset(
            _assetPath,
            fit: fit,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => const _ProductImageFallback(),
          );

    if (borderRadius == null) {
      return child;
    }

    return ClipRRect(
      borderRadius: borderRadius!,
      child: child,
    );
  }
}

class _ProductImageFallback extends StatelessWidget {
  const _ProductImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.secondary.withOpacity(0.08),
      child: const Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          color: AppColors.secondary,
          size: 42,
        ),
      ),
    );
  }
}
