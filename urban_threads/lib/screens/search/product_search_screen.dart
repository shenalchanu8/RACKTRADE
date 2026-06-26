import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/theme_extensions.dart';
import '../../models/product_model.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_image.dart';
import '../product/product_detail_screen.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _lastSearches = [
    'Electronics',
    'Bags',
    'Clothing',
    'Shoes'
  ];
  String _query = '';
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = _filteredProducts(productProvider.allProducts);
    final isSearching = _query.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            Expanded(
              child: isSearching || _selectedFilter != 'All'
                  ? _buildSearchResults(products)
                  : _buildSearchSuggestions(productProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
              onSubmitted: _saveSearch,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: context.appTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search products',
                hintStyle: GoogleFonts.poppins(color: context.appTextLight),
                prefixIcon:
                    Icon(Icons.search_rounded, color: context.appTextLight),
                suffixIcon: _query.isEmpty
                    ? Icon(Icons.tune_rounded, color: context.appTextLight)
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _query = '';
                            _selectedFilter = 'All';
                          });
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          color: context.appTextLight,
                        ),
                      ),
                filled: true,
                fillColor: context.appSurface,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: context.appBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.secondary,
                    width: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions(ProductProvider provider) {
    final popularProducts = provider.allProducts.take(4).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Last Search',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.appTextPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(_lastSearches.clear);
              },
              child: Text(
                'Clear All',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _lastSearches.map(_buildSearchChip).toList(),
        ),
        const SizedBox(height: 28),
        Text(
          'Popular Search',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: context.appTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...popularProducts.asMap().entries.map((entry) {
          final labels = ['Hot', 'New', 'Popular', 'New'];
          return _buildPopularItem(entry.value, labels[entry.key]);
        }),
      ],
    );
  }

  Widget _buildSearchChip(String text) {
    return GestureDetector(
      onTap: () {
        _searchController.text = text;
        setState(() {
          _query = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: context.appTextSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.close_rounded, size: 14, color: context.appTextLight),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItem(Product product, String label) {
    final isHot = label == 'Hot';
    final isPopular = label == 'Popular';

    return GestureDetector(
      onTap: () {
        _searchController.text = product.name;
        setState(() {
          _query = product.name;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            SizedBox(
              width: 58,
              height: 58,
              child: ProductImage(
                imageUrl: product.imageUrl,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.appTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${product.reviews} searches today',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: context.appTextLight,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 64,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isHot
                    ? const Color(0xFFFFE4E4)
                    : isPopular
                        ? const Color(0xFFD9FBE8)
                        : const Color(0xFFFFEDE2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: isHot
                      ? AppColors.error
                      : isPopular
                          ? AppColors.success
                          : const Color(0xFFFF7A45),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<Product> products) {
    return Column(
      children: [
        SizedBox(
          height: 44,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            scrollDirection: Axis.horizontal,
            children: ['All', 'Latest', 'Most Popular', 'Cheapest']
                .map(_buildFilterChip)
                .toList(),
          ),
        ),
        Expanded(
          child: products.isEmpty
              ? Center(
                  child: Text(
                    'No products found',
                    style: GoogleFonts.poppins(
                      color: context.appTextSecondary,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _buildResultCard(products[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _selectedFilter = label;
          });
        },
        selectedColor: AppColors.secondary,
        backgroundColor: context.appSurface,
        side: BorderSide(
          color: isSelected ? AppColors.secondary : context.appBorder,
        ),
        labelStyle: GoogleFonts.poppins(
          color: isSelected ? Colors.white : context.appTextSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildResultCard(Product product) {
    return GestureDetector(
      onTap: () {
        _saveSearch(_query);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ProductImage(
                    imageUrl: product.imageUrl,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _FavoriteButton(product: product),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
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
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: context.appTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  List<Product> _filteredProducts(List<Product> source) {
    var products = source.where((product) {
      final query = _query.toLowerCase().trim();
      if (query.isEmpty) {
        return true;
      }
      return product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          (product.brand?.toLowerCase().contains(query) ?? false);
    }).toList();

    switch (_selectedFilter) {
      case 'Latest':
        products = products.where((product) => product.isNew).toList();
        break;
      case 'Most Popular':
        products.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;
      case 'Cheapest':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
    }

    return products;
  }

  void _saveSearch(String value) {
    final search = value.trim();
    if (search.isEmpty) {
      return;
    }
    setState(() {
      _lastSearches.removeWhere(
        (item) => item.toLowerCase() == search.toLowerCase(),
      );
      _lastSearches.insert(0, search);
      if (_lastSearches.length > 6) {
        _lastSearches.removeLast();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _FavoriteButton extends StatelessWidget {
  final Product product;

  const _FavoriteButton({required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final isFavorite = favoriteProvider.isFavorite(product.id);
        return Material(
          color: context.appSurface.withValues(alpha: 0.88),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => favoriteProvider.toggleFavorite(product),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? AppColors.error : context.appTextSecondary,
                size: 18,
              ),
            ),
          ),
        );
      },
    );
  }
}
