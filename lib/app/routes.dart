import 'package:bilibo/ui/MainScreen.dart';
import 'package:flutter/material.dart';
// import '../features/cart/screens/cart_screen.dart';

class AppRoutes {
  static const home = '/';
  // static const cart = '/cart';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const Mainscreen(),
    // cart: (context) => const CartScreen(),
  };
}
