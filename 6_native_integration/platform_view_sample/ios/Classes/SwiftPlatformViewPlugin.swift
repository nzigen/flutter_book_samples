import Flutter
import UIKit
import WebKit

public class SwiftPlatformViewPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = FLWebViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "platform-web-view")
    }
}

class FLWebViewFactory: NSObject, FlutterPlatformViewFactory {
    private weak var messenger: FlutterBinaryMessenger?

    init(messenger: FlutterBinaryMessenger) {
        super.init()
        self.messenger = messenger
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLWebView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger
        )
    }

    // Flutter側からcreationParamsを受け取る際のCodecのインスタンスを指定する
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLWebView: NSObject, FlutterPlatformView {
    private var webView: WKWebView?

    init(
        frame _: CGRect,
        viewIdentifier _: Int64,
        arguments: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        super.init()
        let params = arguments as! [String: String]
        let initialUrl = params["initialUrl"]!
        webView = WKWebView()
        webView?.load(URLRequest(url: URL(string: initialUrl)!))

        // WebViewの操作用のChannelを作成します
        let channel = FlutterMethodChannel(name: "platform-web-view/channel", binaryMessenger: messenger!)
        channel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "loadUrl":
                let arguments = call.arguments as! [String: String]
                guard let url = arguments["url"], url != "" else {
                    result(FlutterError(code: "InvalidUrl", message: "無効なURLです", details: nil))
                    return
                }
                self?.loadUrl(url: url)
                result(nil)
            case "goBack":
                self?.goBack()
                result(nil)
            case "goForward":
                self?.goForward()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // URLをロードし、WebViewに反映します
    func loadUrl(url: String) {
        webView?.load(URLRequest(url: URL(string: url)!))
    }

    // WebViewのページを戻します
    func goBack() {
        webView?.goBack()
    }

    // WebViewのページを進ませます
    func goForward() {
        webView?.goForward()
    }

    func view() -> UIView {
        return webView!
    }
}
