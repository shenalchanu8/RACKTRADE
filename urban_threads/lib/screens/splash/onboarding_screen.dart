import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../config/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../screens/Auth/register_screen.dart';
import '../../screens/Auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingData = [
    OnboardingItem(
      title: 'Various Collections Of The',
      subtitle:
          'Urna amet, suspendisse ullamcorper ac elit diam facilisis cursus vestibulum.',
      image: 'assets/images/onboarding_1.jpg',
      icon: Icons.shopping_bag_outlined,
    ),
    OnboardingItem(
      title: 'Complete Collection Of',
      subtitle:
          'Urna amet, suspendisse ullamcorper ac elit diam facilisis cursus vestibulum.',
      image: 'assets/images/onboarding_2.jpg',
      icon: Icons.style_outlined,
    ),
    OnboardingItem(
      title: 'Find The Most Suitable',
      subtitle:
          'Urna amet, suspendisse ullamcorper ac elit diam facilisis cursus vestibulum.',
      image: 'assets/images/onboarding_3.jpg',
      icon: Icons.emoji_objects_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    _navigateToLogin();
                  },
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingData[index]);
                },
              ),
            ),
            // Bottom Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Page Indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _onboardingData.length,
                    effect: const WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColors.secondary,
                      dotColor: Color(0xFFD1D5DB),
                    ),
                    onDotClicked: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Buttons
                  if (_currentPage == _onboardingData.length - 1)
                    Column(
                      children: [
                        CustomButton(
                          text: 'Create Account',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already Have an Account?',
                              style: GoogleFonts.poppins(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _navigateToLogin();
                              },
                              child: Text(
                                'Sign In',
                                style: GoogleFonts.poppins(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    CustomButton(
                      text: 'Next',
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image container
          Container(
            width: 380,
            height: 380,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: AppColors.secondary.withOpacity(0.08),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Title
          Text(
            item.title,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Subtitle
          Text(
            item.subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}

class OnboardingItem {
  final String title;
  final String subtitle;
  final String image;
  final IconData icon;

  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.icon,
  });
}
