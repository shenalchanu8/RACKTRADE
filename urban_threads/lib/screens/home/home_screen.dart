import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/product_provider.dart';
import '../../config/app_colors.dart';
import '../../widgets/product_image.dart';
import '../product/product_detail_screen.dart';
import '../search/product_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final carousel_slider.CarouselSliderController _carouselController =
      carousel_slider.CarouselSliderController();
  int _currentBannerIndex = 0;

  final List<Map<String, String>> _banners = [
    {
      'title': 'Flash Shipping Deal',
      'subtitle': '24% off bag purchases today',
      'store': 'Shop Bags',
      'label': 'Limited Offer',
      'color': '#FF6B6B',
      'accent': '#FFD166',
    },
    {
      'title': 'New Collection',
      'subtitle': 'Spring/Summer 2024',
      'store': 'Explore Now',
      'label': 'Urban Threads',
      'color': '#6C5CE7',
      'accent': '#A29BFE',
    },
    {
      'title': 'Free Shipping',
      'subtitle': 'on orders over \$50',
      'store': 'Order Today',
      'label': 'Weekend Drop',
      'color': '#00B894',
      'accent': '#55EFC4',
    },
  ];

  final List<Map<String, String?>> _categories = [
    {'name': 'All', 'icon': null},
    {'name': 'Clothing', 'icon': 'assets/icons/category_clothing.png'},
    {'name': 'Bags', 'icon': 'assets/icons/category_bags.png'},
    {'name': 'Shoes', 'icon': 'assets/icons/category_shoes.png'},
    {'name': 'Electronics', 'icon': 'assets/icons/category_electronics.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Carousel
                _buildBannerCarousel(),
                const SizedBox(height: 24),

                // Category Section with Counts
                _buildCategorySection(productProvider),
                const SizedBox(height: 24),

                // Product Section
                _buildProductSection(productProvider),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    final userName = context.watch<AuthProvider>().userName?.trim();
    final displayName =
        userName == null || userName.isEmpty ? 'Customer' : userName;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: const Padding(
        padding: EdgeInsets.all(12),
        child: CircleAvatar(
          backgroundColor: AppColors.secondary,
          child: Icon(Icons.person, color: Colors.white),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, $displayName',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "Let's go shopping",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductSearchScreen()),
            );
          },
          icon: const Icon(Icons.search_rounded),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined),
        ),
      ],
    );
  }

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        carousel_slider.CarouselSlider(
          carouselController: _carouselController,
          options: carousel_slider.CarouselOptions(
            height: 184,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            viewportFraction: 0.86,
            enlargeCenterPage: true,
          ),
          items: _banners.map((banner) {
            return _buildPromoCard(banner);
          }).toList(),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: _currentBannerIndex,
          count: _banners.length,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: AppColors.secondary,
            dotColor: Color(0xFFD1D5DB),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard(Map<String, String> banner) {
    final baseColor =
        Color(int.parse(banner['color']!.substring(1), radix: 16) + 0xFF000000);
    final accentColor = Color(
      int.parse(banner['accent']!.substring(1), radix: 16) + 0xFF000000,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: baseColor.withOpacity(0.24),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      baseColor,
                      Color.lerp(baseColor, Colors.black, 0.08)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -46,
              right: -30,
              child: _buildGlowCircle(132, accentColor.withOpacity(0.26)),
            ),
            Positioned(
              bottom: -52,
              left: -28,
              child: _buildGlowCircle(118, Colors.white.withOpacity(0.12)),
            ),
            Positioned(
              right: 22,
              bottom: 18,
              child: Icon(
                Icons.local_mall_outlined,
                color: Colors.white.withOpacity(0.18),
                size: 76,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.22),
                            ),
                          ),
                          child: Text(
                            banner['label']!,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          banner['title']!,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            height: 1.05,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          banner['subtitle']!,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.82),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            banner['store']!,
                            style: GoogleFonts.poppins(
                              color: baseColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.28)),
                    ),
                    child: Icon(
                      Icons.checkroom_outlined,
                      color: Colors.white.withOpacity(0.95),
                      size: 34,
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

  Widget _buildGlowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildCategorySection(ProductProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => provider.filterByCategory('All'),
                child: Text(
                  'See All',
                  style: GoogleFonts.poppins(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Horizontal scrollable categories
        SizedBox(
          height: 116,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final categoryName = category['name']!;
              final iconPath = category['icon'];
              final isSelected = provider.selectedCategory == categoryName;
              final count = provider.countForCategory(categoryName);

              return GestureDetector(
                onTap: () => provider.filterByCategory(categoryName),
                child: Container(
                  width: 104,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondary : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.secondary : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : AppColors.secondary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: iconPath == null
                            ? Icon(
                                Icons.grid_view_rounded,
                                color: AppColors.secondary,
                                size: 28,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(6),
                                child: Image.asset(
                                  iconPath,
                                  fit: BoxFit.contain,
                                ),
                              ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        categoryName,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                              isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$count ${count == 1 ? 'Product' : 'Products'}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: isSelected
                              ? Colors.white70
                              : AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductSection(ProductProvider provider) {
    final products = provider.selectedCategory == 'All'
        ? provider.newArrivals
        : provider.products;
    final title = provider.selectedCategory == 'All'
        ? 'New Arrivals'
        : provider.selectedCategory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: GoogleFonts.poppins(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (products.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('No products found')),
          )
        else
          _buildHorizontalProductList(products),
      ],
    );
  }

  Widget _buildHorizontalProductList(List<Product> products) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Expanded(
                      flex: 6,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ProductImage(
                              imageUrl: product.imageUrl,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Consumer<FavoriteProvider>(
                              builder: (context, favoriteProvider, child) {
                                final isFavorite =
                                    favoriteProvider.isFavorite(product.id);
                                return Material(
                                  color: Colors.white.withOpacity(0.88),
                                  shape: const CircleBorder(),
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () => favoriteProvider
                                        .toggleFavorite(product),
                                    child: Padding(
                                      padding: const EdgeInsets.all(7),
                                      child: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? AppColors.error
                                            : AppColors.textSecondary,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Product Details
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Lisa Robber',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
