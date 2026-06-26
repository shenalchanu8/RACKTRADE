import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_colors.dart';
import '../../config/theme_extensions.dart';
import '../../widgets/custom_button.dart';
import '../main/main_screen.dart';

class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                ),
                child: const Icon(
                  Icons.person_add_alt_1,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Register Success',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: context.appTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Congratulations! your account already created.\nPlease login to get amazing experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: context.appTextSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'Go to Homepage',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
