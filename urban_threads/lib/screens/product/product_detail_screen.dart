import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
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

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 330,
              child: Hero(
                tag: widget.product.id,
                child: ProductImage(
                  imageUrl: widget.product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _buildTopBar(context),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.product.name,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildFavoriteButton(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: widget.product.rating,
                            itemBuilder: (_, __) => const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFB800),
                            ),
                            itemCount: 1,
                            itemSize: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.product.rating.toStringAsFixed(1)} (${widget.product.reviews} Review)',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Available in stock',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      if (widget.product.colors.isNotEmpty) ...[
                        Text(
                          'Color',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 12,
                          children: widget.product.colors
                              .map(_buildColorDot)
                              .toList(),
                        ),
                        const SizedBox(height: 18),
                      ],
                      Text(
                        'Description',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.product.description} Read More',
                        style: GoogleFonts.poppins(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.7,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Text(
                            'Choose amount:',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          _buildQuantityControl(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Price',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textLight,
                                  ),
                                ),
                                Text(
                                  '\$${total.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
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
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              icon: const Icon(Icons.shopping_bag_outlined),
                              label: Text(
                                'Add to Cart',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Detail Product',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _addToCart,
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final isFavorite = favoriteProvider.isFavorite(widget.product.id);
        return Material(
          color: const Color(0xFFF7F7FA),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => favoriteProvider.toggleFavorite(widget.product),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? AppColors.error : AppColors.textSecondary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorDot(String colorName) {
    final color = _colorFromName(colorName);
    final isSelected = _selectedColor == colorName;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = colorName;
        });
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            width: 3,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
            : null,
      ),
    );
  }

  Widget _buildQuantityControl() {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F8),
        borderRadius: BorderRadius.circular(18),
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
            width: 34,
            child: Center(
              child: Text(
                '$_quantity',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          _qtyButton(Icons.add, () {
            setState(() => _quantity++);
          }, filled: true),
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
          color: filled ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: filled ? Colors.white : AppColors.textSecondary,
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
      case 'tan':
        return const Color(0xFFB46B5A);
      case 'red':
        return AppColors.error;
      case 'blue':
      case 'navy':
        return const Color(0xFF2DAEC4);
      case 'green':
        return const Color(0xFF00C875);
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'pink':
        return const Color(0xFFE96BA8);
      case 'orange':
      case 'yellow':
        return const Color(0xFFFFB347);
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
