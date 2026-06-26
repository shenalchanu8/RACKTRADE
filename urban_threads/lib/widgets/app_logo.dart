import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AppLogo({
    super.key,
    this.size = 100,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Image
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size * 0.15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.15),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if logo image is not found
                return Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(size * 0.15),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                          size: size * 0.4,
                        ),
                        SizedBox(height: size * 0.05),
                        Text(
                          'RACK TREND',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size * 0.12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(height: size * 0.12),
          Text(
            'RACK TREND',
            style: GoogleFonts.poppins(
              fontSize: size * 0.22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 2,
            ),
          ),
          Text(
            'APPAREL',
            style: GoogleFonts.poppins(
              fontSize: size * 0.14,
              fontWeight: FontWeight.w500,
              color: AppColors.secondary,
              letterSpacing: 4,
            ),
          ),
        ],
      ],
    );
  }
}
