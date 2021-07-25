package com.nzigen.flutterbooksamples.platform_view

import android.content.Context
import android.view.View
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/** PlatformViewPlugin */
public class PlatformViewPlugin : FlutterPlugin {
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterPluginBinding
                .platformViewRegistry
                .registerViewFactory("platform-web-view", FlutterWebViewFactory(flutterPluginBinding.binaryMessenger))
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            registrar
                    .platformViewRegistry()
                    .registerViewFactory("platform-web-view", FlutterWebViewFactory(registrar.messenger()))
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {}
}

class FlutterWebViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return FlutterWebView(context, messenger, id, creationParams)
    }
}

class FlutterWebView(context: Context, messenger: BinaryMessenger, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val webView: WebView = WebView(context)

    override fun getView(): View {
        return webView
    }

    override fun dispose() {}

    init {
        webView.webViewClient = WebViewClient()
        val initialUrl = creationParams?.get("initialUrl") as String
        initialUrl.let {
            webView.loadUrl(it)
        }

        // WebViewの操作用のChannelを作成します
        val channel = MethodChannel(messenger, "platform-web-view/channel")
        channel.setMethodCallHandler { call: MethodCall, result: Result ->
            if (call.method == "loadUrl") {
                val arguments = call.arguments as Map<String?, String?>
                val url = arguments["url"] ?: ""
                val validUrl = url.ifEmpty {
                    result.error("InvalidUrl", "無効なURLです", null)
                    return@setMethodCallHandler
                }
                loadUrl(validUrl)
                result.success(null)
                return@setMethodCallHandler
            }
            if (call.method == "goBack") {
                goBack()
                result.success(null)
                return@setMethodCallHandler
            }
            if (call.method == "goForward") {
                goForward()
                result.success(null)
                return@setMethodCallHandler
            }
            result.notImplemented()
        }
    }

    // URLをロードし、WebViewに反映します
    private fun loadUrl(url: String) {
        webView.loadUrl(url)
    }

    // WebViewのページを戻します
    private fun goBack() {
        webView.goBack()
    }

    // WebViewのページを進ませます
    private fun goForward() {
        webView.goForward()
    }
}
