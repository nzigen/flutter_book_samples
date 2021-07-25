package com.nzigen.flutterbooksamples.platform_channel


import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkInfo
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


/** PlatformChannelPlugin */
public class PlatformChannelPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var connectivityManager: ConnectivityManager
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        setUp(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
    }

    // onAttachedToEngineと同等の処理
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val instance = PlatformChannelPlugin()
            instance.setUp(registrar.context(), registrar.messenger())
        }
    }

    fun setUp(context: Context, messenger: BinaryMessenger) {
        connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        // Flutter側と対応したチャンネル名を用いる
        channel = MethodChannel(messenger, "platform_channel")
        // MethodChannelのハンドラーを設定
        channel.setMethodCallHandler(this);
        // Flutter側と対応したイベントチャンネル名を用いる
        eventChannel = EventChannel(messenger, "platform_channel/event_channel")
        // EventChannelのハンドラーを設定
        eventChannel.setStreamHandler(ConnectivityStreamHandler(context, connectivityManager))
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "isReachable") {
            val activeNetwork: NetworkInfo? = connectivityManager.activeNetworkInfo
            result.success(activeNetwork?.isConnected ?: false)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

class ConnectivityStreamHandler(private val context: Context, private val connectivityManager: ConnectivityManager) : BroadcastReceiver(), StreamHandler {
    private var eventSink: EventSink? = null

    override fun onReceive(context: Context, intent: Intent) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val network: Network? = connectivityManager.activeNetwork
            network ?: run {
                eventSink?.success(0)
                return
            }
            val capabilities: NetworkCapabilities = connectivityManager.getNetworkCapabilities(network)
            if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
                    || capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)) {
                eventSink?.success(2)
                return
            }
            if (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)) {
                eventSink?.success(1)
                return
            }
        }
        TODO("VERSION.SDK_INT < M")
    }

    override fun onListen(arguments: Any?, events: EventSink?) {
        eventSink = events
        // 通知を受け取るレシーバーを定義する
        context.registerReceiver(this, IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION))
    }

    override fun onCancel(arguments: Any?) {
        eventSink.let {
            eventSink = null
        }
        context.unregisterReceiver(this)
    }
}
