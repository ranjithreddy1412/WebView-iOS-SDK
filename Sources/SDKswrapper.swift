//
// SDKWrapper.swift
// Wrapper for exposing public SDK methods
//
//  Created by ranjith kumar reddy b perkampally on 12/15/24.
//

import SwiftUI
import SafariServices
import WebKit

// Wrapper class to expose SDK functionality
public class SDKWrapper {
    private let webViewSDK = WebViewIOSSDK()

    public init() {}

    /// Method to make a network call
    public func makeNetworkCall(url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        webViewSDK.makeNetworkCall(url: url, completion: completion)
    }

    /// Method to navigate to WebView or SafariView
    public func navigate(using url: URL, openInSafari: Bool, completion: @escaping (ViewType) -> Void) {
        webViewSDK.navigateToWebView(using: url, openInSafari: openInSafari, completion: completion)
    }

    /// Helper enum for view types
    public enum ViewType {
        case safari(URL)
        case web(URL)
    }
}

// Internal SafariView class
internal struct SafariView: UIViewControllerRepresentable {
    let url: URL

    init(url: URL) {
        self.url = url
    }

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// Internal WebView class
internal struct WebView: UIViewRepresentable {
    let url: URL
    var messageHandler: WebViewMessageHandler
    @Binding var isDismissed: WebViewIOSSDK.ViewType?

    init(url: URL, messageHandler: WebViewMessageHandler, isDismissed: Binding<WebViewIOSSDK.ViewType?>) {
        self.url = url
        self.messageHandler = messageHandler
        self._isDismissed = isDismissed
    }

    class Coordinator: NSObject, WKScriptMessageHandler {
        var parent: WebView

        init(parent: WebView) {
            self.parent = parent
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if let messageBody = message.body as? String {
                if let data = messageBody.data(using: .utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let action = json["action"] as? String,
                           action == "dismiss" {
                            DispatchQueue.main.async {
                                self.parent.isDismissed = nil
                            }
                        }
                    } catch {
                        print("Failed to parse JSON message: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "iosHandler")
        config.userContentController = contentController

        return WKWebView(frame: .zero, configuration: config)
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

// Internal protocol for WebView message handling
internal protocol WebViewMessageHandler {
    func onMessageReceived(_ message: String)
}
