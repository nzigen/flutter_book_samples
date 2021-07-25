import 'package:flutter/material.dart';

class PurchaseStatusNotifier with ChangeNotifier {
  PurchaseStatusNotifier({
    this.isPurchased = false,
  });

  late bool isPurchased;

  void updatePurchaseStatus(bool currentStatus) {
    isPurchased = currentStatus;
  }
}
