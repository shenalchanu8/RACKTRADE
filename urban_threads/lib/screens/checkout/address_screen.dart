import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_colors.dart';
import '../../config/theme_extensions.dart';
import '../../models/cart_item_model.dart';
import 'payment_screen.dart';

class AddressScreen extends StatefulWidget {
  final List<CartItem> checkoutItems;

  const AddressScreen({
    super.key,
    required this.checkoutItems,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String _selectedAddress = 'Los Angeles';

  final List<Map<String, dynamic>> _addresses = [
    {
      'city': 'Los Angeles',
      'detail': 'Los Angeles, United States',
      'color': const Color(0xFF2EE7C8),
    },
    {
      'city': 'San Francisco',
      'detail': 'San Francisco, United States',
      'color': AppColors.secondary,
    },
    {
      'city': 'New York',
      'detail': 'New York, United States',
      'color': const Color(0xFFFF6B87),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        backgroundColor: context.appBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        centerTitle: true,
        title: Text(
          'Address',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: context.appTextPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your location',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a location below to get started.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  height: 1.6,
                  color: context.appTextSecondary,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.appBorder, width: 1.2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        color: context.appTextSecondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'San Diego, CA',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: context.appTextPrimary,
                        ),
                      ),
                    ),
                    Icon(Icons.my_location_rounded,
                        color: context.appTextSecondary),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Select location',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: _addresses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final address = _addresses[index];
                    final isSelected = _selectedAddress == address['city'];
                    return _buildLocationCard(address, isSelected);
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentScreen(
                          checkoutItems: widget.checkoutItems,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(Map<String, dynamic> address, bool isSelected) {
    final pinColor = address['color'] as Color;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAddress = address['city'] as String;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.secondary : context.appBorder,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address['city'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: context.appTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address['detail'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: context.appTextLight,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: pinColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.secondary : context.appBorder,
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: pinColor,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
