import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'purchase/purchase_status_notifier.dart';
import 'widgets/confirm_dialog.dart';

class HomeScreenModel extends ChangeNotifier {
  HomeScreenModel({
    required this.context,
    required this.purchaseStatusNotifier,
  }) {
    initPlatformState();
  }

  final BuildContext context;
  final PurchaseStatusNotifier purchaseStatusNotifier;
  late Offerings _offerings;

  bool _isLoading = false;
  bool _isNetworkConnected = true;
  bool get isLoading => _isLoading;

  void updateLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> initPlatformState() async {
    try {
      await Purchases.setDebugLogsEnabled(true);
      // 実際のプロジェクトIDへ変更する必要があります
      // 有効なプロジェクトID設定前にはExceptionが発生します
      await Purchases.setup('SAMPLE');
      _offerings = await Purchases.getOfferings();
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      debugPrint(errorCode.toString());
      if (errorCode == PurchasesErrorCode.networkError) {
        _isNetworkConnected = false;
      }
    }
  }

  void checkNetworkConnection() {
    if (!_isNetworkConnected) {
      // ネットワーク接続がないときのダイアログ表示
      ConfirmDialog(context).showConfirmDialog(
        title: 'ネットワーク通信がありません',
        message: '通信状態の良い場所で、再起動後にお試しください。',
      );
    }
  }

  // 購入状態を取得し、処理分岐
  void checkPurchaseStatus() {
    // 購入済み
    if (purchaseStatusNotifier.isPurchased) {
      return;
    }
    // 購入処理開始
    updateLoading();
    purchaseItem();
  }

  // Product購入処理関数
  void purchaseItem() async {
    try {
      final offering = _offerings.current;

      // Revenue Catコンソールで作成したOffering IDへ変更してください
      final noAdsPackage = offering!.getPackage('NoAds');
      final purchaserInfo = await Purchases.purchasePackage(noAdsPackage!);

      // Revenue Catコンソールで作成したEntitlement IDへ変更してください
      final isNoAds = purchaserInfo.entitlements.all['NoAds']!.isActive;
      if (isNoAds) {
        // PurchaseNotifierの値を購入済みへ更新
        // Revenue Catコンソールで作成したEntitlement IDへ変更してください
        purchaseStatusNotifier.updatePurchaseStatus(
            purchaserInfo.entitlements.all['NoAds']!.isActive);
        ConfirmDialog(context).showConfirmDialog(
          title: '購入完了',
          message: '購入が正常に完了しました。',
        );
      }
    } on PlatformException catch (error) {
      ConfirmDialog(context).showConfirmDialog(
        title: '購入処理がキャンセルされました。',
        message: error.toString(),
      );
    }
    updateLoading();
  }

  // 購入情報復元関数
  void restoreTransactions() async {
    try {
      _isLoading = true;
      notifyListeners();

      // 過去の購入情報を取得
      final restoredPurchase = await Purchases.restoreTransactions();

      // Revenue Catコンソールで作成したEntitlement IDへ変更してください
      if (restoredPurchase.entitlements.all['NoAds']!.isActive) {
        // 購入状態を更新します
        purchaseStatusNotifier.updatePurchaseStatus(
            restoredPurchase.entitlements.all['NoAds']!.isActive);

        // 復元完了のポップアップ
        ConfirmDialog(context).showConfirmDialog(
          title: '購入復元が完了しました',
        );
      } else {
        // 購入情報が見つからない場合
        ConfirmDialog(context).showConfirmDialog(title: '購入情報が見つかりませんでした');
      }
    } on PlatformException catch (error) {
      // 特定のエラーメッセージを表示します
      ConfirmDialog(context).showConfirmDialog(
        title: '購入情報が見つかりませんでした',
        message: error.toString(),
      );
    }
    _isLoading = false;
    notifyListeners();
  }
}
