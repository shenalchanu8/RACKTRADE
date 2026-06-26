import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/theme_extensions.dart';
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
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            if (cartProvider.items.isEmpty) {
              return _buildEmptyCart();
            }

            _syncSelected(cartProvider.items);
            final selectedItems = cartProvider.items
                .where((item) => _selectedIds.contains(_itemKey(item)))
                .toList();
            final selectedCount = selectedItems.fold<int>(
              0,
              (total, item) => total + item.quantity,
            );
            final subtotal = selectedItems.fold<double>(
              0,
              (total, item) => total + item.subtotal,
            );
            final shipping = selectedItems.isEmpty ? 0.0 : 6.00;
            final total = subtotal + shipping;

            return Column(
              children: [
                _buildHeader(cartProvider.items.length),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    children: [
                      _buildSelectionBar(
                        items: cartProvider.items,
                        selectedItems: selectedItems,
                        cartProvider: cartProvider,
                      ),
                      const SizedBox(height: 14),
                      ...cartProvider.items.map(
                        (item) {
                          final key = _itemKey(item);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _buildCartCard(
                              item: item,
                              isSelected: _selectedIds.contains(key),
                              onSelected: () => _toggleItem(key),
                              onQuantityChanged: (quantity) {
                                cartProvider.updateCartItemQuantity(
                                  item,
                                  quantity,
                                );
                              },
                              onRemove: () {
                                cartProvider.removeCartItem(item);
                                setState(() => _selectedIds.remove(key));
                              },
                            ),
                          );
                        },
                      ),
                      _buildDeliveryCard(),
                      const SizedBox(height: 14),
                      _buildPromoCard(),
                    ],
                  ),
                ),
                _buildSummaryPanel(
                  context: context,
                  selectedCount: selectedCount,
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
      ),
    );
  }

  Widget _buildHeader(int itemCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Row(
        children: [
          _buildHeaderButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.maybePop(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Cart',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: context.appTextPrimary,
                  ),
                ),
                Text(
                  '$itemCount ${itemCount == 1 ? 'item' : 'items'} ready for checkout',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: context.appTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _buildHeaderButton(
            icon: Icons.shopping_bag_outlined,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionBar({
    required List<CartItem> items,
    required List<CartItem> selectedItems,
    required CartProvider cartProvider,
  }) {
    final isAllSelected = selectedItems.length == items.length;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (isAllSelected) {
                  _selectedIds.clear();
                } else {
                  _selectedIds
                    ..clear()
                    ..addAll(items.map(_itemKey));
                }
              });
            },
            child: _buildCheckBox(isAllSelected),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isAllSelected ? 'All items selected' : 'Select all items',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: context.appTextPrimary,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: selectedItems.isEmpty
                ? null
                : () {
                    cartProvider.removeItems(selectedItems);
                    setState(() => _selectedIds.clear());
                  },
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            label: Text(
              'Remove',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartCard({
    required CartItem item,
    required bool isSelected,
    required VoidCallback onSelected,
    required ValueChanged<int> onQuantityChanged,
    required VoidCallback onRemove,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? AppColors.secondary.withValues(alpha: 0.42)
              : context.appBorder,
          width: isSelected ? 1.4 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onSelected,
            child: Padding(
              padding: const EdgeInsets.only(top: 34),
              child: _buildCheckBox(isSelected),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 92,
            height: 108,
            child: ProductImage(
              imageUrl: item.product.imageUrl,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 108,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.product.name,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            height: 1.25,
                            fontWeight: FontWeight.w800,
                            color: context.appTextPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: onRemove,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.close_rounded,
                            color: context.appTextLight,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildVariantChip(
                        'Color: ${item.selectedColor.isEmpty ? 'Default' : item.selectedColor}',
                      ),
                      if (item.selectedSize.isNotEmpty)
                        _buildVariantChip('Size: ${item.selectedSize}'),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '\$${item.subtotal.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondary,
                        ),
                      ),
                      const Spacer(),
                      _buildQuantityControl(item.quantity, onQuantityChanged),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControl(
    int quantity,
    ValueChanged<int> onQuantityChanged,
  ) {
    return Container(
      height: 34,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: context.appSurfaceSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _quantityButton(
            Icons.remove,
            () => onQuantityChanged(quantity - 1),
          ),
          SizedBox(
            width: 32,
            child: Center(
              child: Text(
                '$quantity',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: context.appTextPrimary,
                ),
              ),
            ),
          ),
          _quantityButton(
            Icons.add,
            () => onQuantityChanged(quantity + 1),
            isFilled: true,
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(
    IconData icon,
    VoidCallback onTap, {
    bool isFilled = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isFilled ? AppColors.secondary : context.appSurface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: isFilled ? Colors.white : context.appTextSecondary,
        ),
      ),
    );
  }

  Widget _buildDeliveryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.appSurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Standard delivery',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: context.appTextPrimary,
                  ),
                ),
                Text(
                  'Arrives within 3 to 4 days after checkout',
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

  Widget _buildPromoCard() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.workspace_premium_outlined,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Apply promo code',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: context.appTextSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: context.appTextSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPanel({
    required BuildContext context,
    required int selectedCount,
    required double subtotal,
    required double shipping,
    required double total,
    required bool hasSelection,
    required List<CartItem> checkoutItems,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 18),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EF),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCount == 0
                        ? 'No items selected'
                        : '$selectedCount selected ${selectedCount == 1 ? 'item' : 'items'}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: context.appTextPrimary,
                    ),
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: context.appTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _summaryRow('Subtotal', subtotal),
            const SizedBox(height: 8),
            _summaryRow('Shipping', shipping),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
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
                  disabledBackgroundColor: const Color(0xFFD9DDE6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                icon: const Icon(Icons.lock_outline_rounded, size: 20),
                label: Text(
                  'Checkout Securely',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: context.appTextSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: context.appTextPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
      child: Column(
        children: [
          _buildHeaderButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.maybePop(context),
          ),
          const Spacer(),
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 62,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: context.appTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add products you love and they will appear here for checkout.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: context.appTextSecondary,
              height: 1.6,
              fontSize: 13,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: context.appSurface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(icon, color: context.appTextPrimary, size: 20),
        ),
      ),
    );
  }

  Widget _buildCheckBox(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondary : context.appSurface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: isSelected ? AppColors.secondary : const Color(0xFFD9DDE6),
          width: 1.4,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
          : null,
    );
  }

  Widget _buildVariantChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.appSurfaceSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          color: context.appTextSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _toggleItem(String key) {
    setState(() {
      if (_selectedIds.contains(key)) {
        _selectedIds.remove(key);
      } else {
        _selectedIds.add(key);
      }
    });
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
