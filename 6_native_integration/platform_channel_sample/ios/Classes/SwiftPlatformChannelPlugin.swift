import Flutter
import Reachability
import UIKit

public class SwiftPlatformChannelPlugin: NSObject, FlutterPlugin {
    var reachability: Reachability?

    public static func register(with registrar: FlutterPluginRegistrar) {
        // Flutter側と対応したチャンネル名を用いる
        let channel = FlutterMethodChannel(name: "platform_channel", binaryMessenger: registrar.messenger())
        let instance = SwiftPlatformChannelPlugin()
        instance.reachability = Reachability.forInternetConnection()
        // MethodChannelのハンドラーを設定
        registrar.addMethodCallDelegate(instance, channel: channel)

        // Flutter側と対応したイベントチャンネル名を用いる
        let eventChannel = FlutterEventChannel(name: "platform_channel/event_channel", binaryMessenger: registrar.messenger())
        // EventChannelのハンドラーを設定
        eventChannel.setStreamHandler(RechabilityStreamHandler(reachability: instance.reachability))
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // 呼ばれたメソッド名とネイティブの処理を対応付ける
        if call.method == "isReachable" {
            result(reachability?.isReachable() ?? false)
        }
        result(FlutterMethodNotImplemented)
    }
}

class RechabilityStreamHandler: NSObject, FlutterStreamHandler {
    let reachability: Reachability?
    var eventSink: FlutterEventSink?

    init(reachability: Reachability?) {
        self.reachability = reachability
    }

    public func onListen(withArguments _: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        // 初回の通知が来ないため、一度実行する
        onNetworkStatusChange()
        // ネットワークのステータスの変更通知イベントを受け取れる様に設定する
        NotificationCenter.default.addObserver(self, selector: #selector(onNetworkStatusChange), name: NSNotification.Name.reachabilityChanged, object: nil)
        reachability?.startNotifier()
        return nil
    }

    public func onCancel(withArguments _: Any?) -> FlutterError? {
        eventSink = nil
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
        return nil
    }

    // ネットワークのステータス変更時にEventChannelのSinkへと流し込みます
    @objc private func onNetworkStatusChange() {
        guard let sink = eventSink else {
            return
        }
        let stateValue = reachability?.currentReachabilityStatus().rawValue
        sink(stateValue)
    }
}
