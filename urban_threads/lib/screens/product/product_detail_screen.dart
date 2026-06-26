import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/theme_extensions.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/product_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _selectedColor = '';
  String _selectedSize = '';
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedColor =
        widget.product.colors.isNotEmpty ? widget.product.colors.first : '';
    _selectedSize =
        widget.product.sizes.isNotEmpty ? widget.product.sizes.first : '';
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.product.price * _quantity;
    final imageHeight =
        (MediaQuery.sizeOf(context).height * 0.42).clamp(310.0, 430.0);

    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildImageHeader(context, imageHeight.toDouble()),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -28),
                child: _buildDetailPanel(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(total),
    );
  }

  Widget _buildImageHeader(BuildContext context, double height) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Hero(
              tag: widget.product.id,
              child: ProductImage(
                imageUrl: widget.product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.20),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.16),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 14,
            child: Row(
              children: [
                _buildTopIcon(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                const Spacer(),
                _buildFavoriteButton(isFloating: true),
                const SizedBox(width: 10),
                _buildTopIcon(
                  icon: Icons.shopping_bag_outlined,
                  onTap: _addToCart,
                ),
              ],
            ),
          ),
          if (widget.product.isNew || widget.product.isFeatured)
            Positioned(
              left: 18,
              bottom: 44,
              child: Wrap(
                spacing: 8,
                children: [
                  if (widget.product.isNew) _buildBadge('New Arrival'),
                  if (widget.product.isFeatured) _buildBadge('Featured'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(),
          const SizedBox(height: 18),
          _buildProductHeader(),
          const SizedBox(height: 18),
          _buildRatingAndStock(),
          const SizedBox(height: 22),
          _buildPriceSummary(),
          const SizedBox(height: 24),
          if (widget.product.colors.isNotEmpty) ...[
            _buildSectionTitle('Color'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: widget.product.colors.map(_buildColorOption).toList(),
            ),
            const SizedBox(height: 24),
          ],
          if (widget.product.sizes.isNotEmpty) ...[
            _buildSectionTitle('Size'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.product.sizes.map(_buildSizeOption).toList(),
            ),
            const SizedBox(height: 24),
          ],
          Row(
            children: [
              _buildSectionTitle('Quantity'),
              const Spacer(),
              _buildQuantityControl(),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Description'),
          const SizedBox(height: 10),
          Text(
            widget.product.description,
            style: GoogleFonts.poppins(
              color: context.appTextSecondary,
              fontSize: 13,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildInfoTile(
                  icon: Icons.local_shipping_outlined,
                  title: 'Fast Delivery',
                  subtitle: '3-4 days',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoTile(
                  icon: Icons.verified_outlined,
                  title: 'Secure Order',
                  subtitle: 'Protected',
                ),
              ),
            ],
          ),
          const SizedBox(height: 92),
        ],
      ),
    );
  }

  Widget _buildBottomBar(double total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
      decoration: BoxDecoration(
        color: context.appSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: context.appTextLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: context.appTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 172,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                ),
                icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                label: Text(
                  'Add to Cart',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.product.brand ?? widget.product.category,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: context.appTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildFavoriteButton(),
      ],
    );
  }

  Widget _buildRatingAndStock() {
    return Row(
      children: [
        RatingBarIndicator(
          rating: widget.product.rating,
          itemBuilder: (_, __) => const Icon(
            Icons.star_rounded,
            color: Color(0xFFFFB800),
          ),
          itemCount: 5,
          itemSize: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${widget.product.rating.toStringAsFixed(1)} (${widget.product.reviews} reviews)',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: context.appTextSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            'In Stock',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.success,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appSurfaceSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.sell_outlined,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unit Price',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: context.appTextSecondary,
                  ),
                ),
                Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: context.appTextPrimary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.product.category,
            style: GoogleFonts.poppins(
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton({bool isFloating = false}) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final isFavorite = favoriteProvider.isFavorite(widget.product.id);
        return Material(
          color: isFloating
              ? Colors.white.withValues(alpha: 0.92)
              : context.appSurfaceSoft,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => favoriteProvider.toggleFavorite(widget.product),
            child: Padding(
              padding: const EdgeInsets.all(11),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? AppColors.error : context.appTextSecondary,
                size: 22,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: context.appSurface.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Icon(icon, color: context.appTextPrimary, size: 20),
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildColorOption(String colorName) {
    final color = _colorFromName(colorName);
    final isSelected = _selectedColor == colorName;
    final isLightColor = color.computeLuminance() > 0.72;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = colorName;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withValues(alpha: 0.10)
              : context.appSurfaceSoft,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            width: 1.4,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isLightColor ? Colors.grey.shade300 : color,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 14,
                      color:
                          isLightColor ? context.appTextPrimary : Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              colorName,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color:
                    isSelected ? AppColors.secondary : context.appTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    final isSelected = _selectedSize == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        constraints: const BoxConstraints(minWidth: 46),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : context.appSurfaceSoft,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          size,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: isSelected ? Colors.white : context.appTextPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControl() {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: context.appSurfaceSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qtyButton(Icons.remove, () {
            if (_quantity > 1) {
              setState(() => _quantity--);
            }
          }),
          SizedBox(
            width: 42,
            child: Center(
              child: Text(
                '$_quantity',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          _qtyButton(
            Icons.add,
            () {
              setState(() => _quantity++);
            },
            filled: true,
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap, {bool filled = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: filled ? AppColors.secondary : context.appSurface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: filled ? Colors.white : context.appTextSecondary,
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appSurfaceSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: context.appTextPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: context.appTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: context.appTextPrimary,
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 46,
        height: 5,
        decoration: BoxDecoration(
          color: const Color(0xFFE4E6EB),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  Color _colorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'brown':
        return const Color(0xFF8B5E3C);
      case 'tan':
        return const Color(0xFFD4A373);
      case 'red':
        return AppColors.error;
      case 'blue':
        return const Color(0xFF2DAEC4);
      case 'navy':
        return const Color(0xFF1E3A8A);
      case 'green':
        return const Color(0xFF00C875);
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'pink':
        return const Color(0xFFE96BA8);
      case 'orange':
        return const Color(0xFFFF7A30);
      case 'yellow':
        return const Color(0xFFFFC857);
      default:
        return AppColors.secondary;
    }
  }

  void _addToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    for (int i = 0; i < _quantity; i++) {
      cartProvider.addItem(
        widget.product,
        color: _selectedColor,
        size: _selectedSize,
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
