import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../models/cart_item_model.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product_image.dart';
import '../checkout/address_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Set<String> _selectedIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        centerTitle: true,
        title: Text(
          'My Cart',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
            return _buildEmptyCart();
          }

          _syncSelected(cartProvider.items);
          final selectedItems = cartProvider.items
              .where((item) => _selectedIds.contains(_itemKey(item)))
              .toList();
          final subtotal = selectedItems.fold<double>(
            0,
            (total, item) => total + item.subtotal,
          );
          const shipping = 6.00;
          final total = subtotal + shipping;

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  itemCount: cartProvider.items.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 22,
                    color: Colors.grey.shade100,
                  ),
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    final key = _itemKey(item);
                    return _buildCartRow(
                      item: item,
                      isSelected: _selectedIds.contains(key),
                      onSelected: () {
                        setState(() {
                          if (_selectedIds.contains(key)) {
                            _selectedIds.remove(key);
                          } else {
                            _selectedIds.add(key);
                          }
                        });
                      },
                      onQuantityChanged: (quantity) {
                        cartProvider.updateCartItemQuantity(item, quantity);
                      },
                      onRemove: () {
                        cartProvider.removeCartItem(item);
                        setState(() => _selectedIds.remove(key));
                      },
                    );
                  },
                ),
              ),
              _buildSummaryPanel(
                context: context,
                subtotal: subtotal,
                shipping: shipping,
                total: total,
                hasSelection: selectedItems.isNotEmpty,
                checkoutItems: selectedItems,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartRow({
    required CartItem item,
    required bool isSelected,
    required VoidCallback onSelected,
    required ValueChanged<int> onQuantityChanged,
    required VoidCallback onRemove,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: onSelected,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondary : Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isSelected ? AppColors.secondary : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 14)
                : null,
          ),
        ),
        const SizedBox(width: 14),
        SizedBox(
          width: 74,
          height: 74,
          child: ProductImage(
            imageUrl: item.product.imageUrl,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.product.name,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                      size: 18,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              Text(
                'Color: ${item.selectedColor.isEmpty ? 'Default' : item.selectedColor}',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _quantityButton(Icons.remove, () {
                    onQuantityChanged(item.quantity - 1);
                  }),
                  SizedBox(
                    width: 28,
                    child: Center(
                      child: Text(
                        '${item.quantity}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  _quantityButton(Icons.add, () {
                    onQuantityChanged(item.quantity + 1);
                  }),
                  const Spacer(),
                  Text(
                    '\$${item.subtotal.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: Color(0xFFF6F6F8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildSummaryPanel({
    required BuildContext context,
    required double subtotal,
    required double shipping,
    required double total,
    required bool hasSelection,
    required List<CartItem> checkoutItems,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FA),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium_outlined,
                      color: AppColors.textLight),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Enter your promo code',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _summaryRow('Subtotal', subtotal),
            const SizedBox(height: 12),
            _summaryRow('Shipping', shipping),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            _summaryRow('Total amount', total, isBold: true),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: hasSelection
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddressScreen(
                              checkoutItems: checkoutItems,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Checkout',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontSize: isBold ? 16 : 13,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Your Cart is Empty',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to get started',
            style: GoogleFonts.poppins(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _syncSelected(List<CartItem> items) {
    if (_selectedIds.isEmpty && items.isNotEmpty) {
      _selectedIds.addAll(items.map(_itemKey));
      return;
    }
    final available = items.map(_itemKey).toSet();
    _selectedIds.removeWhere((id) => !available.contains(id));
  }

  String _itemKey(CartItem item) {
    return '${item.product.id}-${item.selectedColor}-${item.selectedSize}';
  }
}
