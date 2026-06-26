import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/theme_provider.dart';
import '../../config/app_colors.dart';
import '../../config/theme_extensions.dart';
import '../orders/order_detail_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final userName = authProvider.userName ?? 'User';
    final userEmail = authProvider.userEmail ?? 'user@email.com';

    return Scaffold(
      backgroundColor: context.appBackground,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileHeader(context, userName, userEmail),
            const SizedBox(height: 24),
            _buildStatsCards(
              context,
              orderProvider.orders.length,
              favoriteProvider.itemCount,
            ),
            const SizedBox(height: 24),
            _buildOrderHistory(context, orderProvider.orders),
            const SizedBox(height: 24),
            _buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name, String email) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.appTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    color: context.appTextSecondary,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified,
                        color: AppColors.success,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit_outlined, color: context.appTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(
    BuildContext context,
    int orderCount,
    int wishlistCount,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Orders',
            orderCount.toString(),
            Icons.shopping_bag_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Wishlist',
            wishlistCount.toString(),
            Icons.favorite_outline,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Reviews',
            '23',
            Icons.star_outline,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.secondary, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.appTextPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: context.appTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHistory(BuildContext context, List<Order> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order History',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.appTextPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (orders.isEmpty)
          _buildEmptyOrders(context)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildOrderCard(context, orders[index]);
            },
          ),
      ],
    );
  }

  Widget _buildEmptyOrders(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            color: context.appTextLight,
            size: 34,
          ),
          const SizedBox(height: 8),
          Text(
            'No orders yet',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: context.appTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Completed checkouts will appear here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: context.appTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final statusColor = _statusColor(order.status);
    final date = DateFormat('MMM d, yyyy').format(order.createdAt);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailScreen(order: order),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${order.id}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: context.appTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${order.itemCount} items - $date',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.appTextSecondary,
                    ),
                  ),
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: context.appTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order.status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final menuItems = [
      {'icon': Icons.location_on_outlined, 'title': 'Address'},
      {'icon': Icons.payment_outlined, 'title': 'Payment Methods'},
      {'icon': Icons.notifications_outlined, 'title': 'Notifications'},
      {'icon': Icons.dark_mode_outlined, 'title': 'Dark Mode'},
      {'icon': Icons.help_outline, 'title': 'Help & Support'},
      {'icon': Icons.logout_outlined, 'title': 'Logout'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: menuItems.map((item) {
          final isDarkMode = item['title'] as String == 'Dark Mode';
          final isLogout = item['title'] as String == 'Logout';

          return ListTile(
            leading: Icon(
              item['icon'] as IconData,
              color: isLogout ? AppColors.error : context.appTextSecondary,
            ),
            title: Text(
              item['title'] as String,
              style: TextStyle(
                color: isLogout ? AppColors.error : context.appTextPrimary,
              ),
            ),
            trailing: isDarkMode
                ? Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Switch(
                        value: themeProvider.isDark,
                        onChanged: (_) => themeProvider.toggleTheme(),
                      );
                    },
                  )
                : Icon(Icons.chevron_right, color: context.appTextSecondary),
            onTap: isDarkMode
                ? null
                : isLogout
                    ? () {
                        _showLogoutDialog(context);
                      }
                    : () {},
          );
        }).toList(),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.secondary;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              final navigator = Navigator.of(context);
              await authProvider.logout();
              navigator.pushReplacementNamed('/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
