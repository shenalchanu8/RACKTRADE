import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/theme_extensions.dart';
import '../../models/product_model.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/product_image.dart';
import '../product/product_detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: context.appBackground,
        elevation: 0,
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          final products = favoriteProvider.items;

          if (products.isEmpty) {
            return _buildEmptyState(context);
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,
              childAspectRatio: 0.68,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => _buildFavoriteCard(
              context,
              products[index],
              favoriteProvider,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                color: AppColors.secondary,
                size: 42,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No favorites yet',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: context.appTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap the heart on any product to save it here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: context.appTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    Product product,
    FavoriteProvider favoriteProvider,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.appBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ProductImage(
                      imageUrl: product.imageUrl,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor:
                            context.appSurface.withValues(alpha: 0.9),
                      ),
                      onPressed: () =>
                          favoriteProvider.removeFavorite(product.id),
                      icon: const Icon(
                        Icons.favorite,
                        color: AppColors.error,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: context.appTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.brand ?? product.category,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: context.appTextLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
