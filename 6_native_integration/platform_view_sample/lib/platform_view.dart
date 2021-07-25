import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class PlatformWebViewWidget extends StatelessWidget {
  const PlatformWebViewWidget({
    Key? key,
    required this.initialUrl,
    this.useHybridComposition = false,
  }) : super(key: key);

  final String initialUrl;
  final bool useHybridComposition;

  @override
  Widget build(BuildContext context) {
    const viewType = 'platform-web-view';
    final creationParams = <String, dynamic>{
      'initialUrl': initialUrl,
    };
    if (Platform.isAndroid) {
      if (useHybridComposition) {
        return PlatformViewLink(
          viewType: viewType,
          surfaceFactory:
              (BuildContext context, PlatformViewController controller) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: const <
                  Factory<OneSequenceGestureRecognizer>>{},
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initSurfaceAndroidView(
              id: params.id,
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
            )
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..create();
          },
        );
      }
      return AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}

class PlatformWebViewController {
  static const MethodChannel _channel =
      MethodChannel('platform-web-view/channel');

  // 入力したURLを反映する
  Future<void> loadUrl(String url) async {
    return await _channel.invokeMethod('loadUrl', {
      'url': url,
    });
  }

  // ページを戻す
  Future<void> goBack() async {
    return await _channel.invokeMethod('goBack');
  }

  // ページを進む
  Future<void> goForward() async {
    return await _channel.invokeMethod('goForward');
  }
}
