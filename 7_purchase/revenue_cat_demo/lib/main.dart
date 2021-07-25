import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revenue_cat_demo/home_screen.dart';

import 'purchase/initialize_purchase.dart';
import 'purchase/purchase_status_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final purchaseHistory = await initializePurchase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PurchaseStatusNotifier(
            isPurchased:
                purchaseHistory.entitlements.active.isEmpty ? false : true,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Revenue Cat Demo',
      home: HomeScreen(),
    );
  }
}
