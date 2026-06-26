import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int cartItemCount;
  final int favoriteItemCount;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartItemCount = 0,
    this.favoriteItemCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItemData(
        icon: Icons.home_rounded,
        label: 'Home',
      ),
      _NavItemData(
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag_rounded,
        label: 'My Order',
      ),
      _NavItemData(
        icon: Icons.favorite_border_rounded,
        activeIcon: Icons.favorite_rounded,
        label: 'Favorite',
      ),
      _NavItemData(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'My Profile',
      ),
    ];
    final counts = [0, cartItemCount, favoriteItemCount, 0];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 16),
        child: Container(
          height: 74,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF12151B),
            borderRadius: BorderRadius.circular(38),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.26),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = currentIndex == index;
              return _NavBarItem(
                item: item,
                count: counts[index],
                isSelected: isSelected,
                onTap: () => onTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final _NavItemData item;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = isSelected ? item.activeIcon ?? item.icon : item.icon;

    return Expanded(
      flex: isSelected ? 2 : 1,
      child: Semantics(
        button: true,
        selected: isSelected,
        label: item.label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(32),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: EdgeInsets.symmetric(horizontal: isSelected ? 14 : 6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF484B51) : Colors.transparent,
              borderRadius: BorderRadius.circular(32),
            ),
            child: isSelected
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _NavIcon(icon: icon, count: count, isSelected: true),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          item.label,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: _NavIcon(
                      icon: icon,
                      count: count,
                      isSelected: false,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool isSelected;

  const _NavIcon({
    required this.icon,
    required this.count,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: isSelected ? 29 : 28,
        ),
        if (count > 0)
          Positioned(
            right: -8,
            top: -7,
            child: _Badge(count: count),
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;

  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      decoration: const BoxDecoration(
        color: AppColors.error,
        shape: BoxShape.circle,
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          height: 1,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const _NavItemData({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}
