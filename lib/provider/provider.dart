import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../features/auth/providers/auth_provider.dart';
// import '../features/products/providers/product_provider.dart';
// import '../features/cart/providers/cart_provider.dart';
// import '../features/orders/providers/order_provider.dart';

class ProviderSetup extends StatelessWidget {
  final Widget child;

  const ProviderSetup({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
    //   MultiProvider(
    //   providers: [
    //     // ChangeNotifierProvider(create: (_) => AuthProvider()),
    //     // ChangeNotifierProvider(create: (_) => ProductProvider()),
    //     // ChangeNotifierProvider(create: (_) => CartProvider()),
    //     // ChangeNotifierProvider(create: (_) => OrderProvider()),
    //   ],
    //   child: child,
    // );
  }
}
