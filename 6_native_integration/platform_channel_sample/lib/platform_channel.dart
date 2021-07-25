import 'dart:async';

import 'package:flutter/services.dart';

class PlatformChannel {
  // MethodChannelの定義
  static const MethodChannel _channel = MethodChannel('platform_channel');
  // EventChannelの定義
  static const EventChannel _eventChannel =
      EventChannel('platform_channel/event_channel');

  // MethodChannelを用いて、ネイティブ側のisReachable関数を実行する
  static Future<bool> get isReachable async {
    return await _channel.invokeMethod('isReachable');
  }

  // EventChannelを通して、ネットワークの接続種類の変更を取得する
  static Stream<int> onNetworkStateChange() {
    return _eventChannel.receiveBroadcastStream().map((event) => event as int);
  }
}
