import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorite_provider.dart';
import '../home/home_screen.dart';
import '../cart/cart_screen.dart';
import '../favorites/favorite_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CartScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Consumer2<CartProvider, FavoriteProvider>(
        builder: (context, cartProvider, favoriteProvider, child) {
          return BottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            cartItemCount: cartProvider.itemCount,
            favoriteItemCount: favoriteProvider.itemCount,
          );
        },
      ),
    );
  }
}
