import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

Future<PurchaserInfo> initializePurchase() async {
  late PurchaserInfo purchaserInfo;
  try {
    await Purchases.setDebugLogsEnabled(true);
    // 実際のプロジェクトIDへ変更する必要があります
    // 有効なプロジェクトID設定前にはExceptionが発生します
    await Purchases.setup('SAMPLE');
    purchaserInfo = await Purchases.getPurchaserInfo();
    debugPrint(purchaserInfo.entitlements.toString());
  } on PlatformException catch (e) {
    final errorCode = PurchasesErrorHelper.getErrorCode(e);
    debugPrint(errorCode.toString());
  }
  return purchaserInfo;
}
