//
//  File.swift
//  WebView-iOS-SDK
//
//  Created by ranjith kumar reddy b perkampally on 11/18/24.
//

import SwiftUI
import WebKit

public protocol WebViewMessageHandler {
    func onMessageReceived(_ message: String)
}

public struct WebView: UIViewRepresentable {
    let url: URL
    var messageHandler: WebViewMessageHandler
    @Binding var isDismissed: WebViewIOSSDK.ViewType?
    
    public init(url: URL, messageHandler: WebViewMessageHandler, isDismissed: Binding<WebViewIOSSDK.ViewType?>) {
        self.url = url
        self.messageHandler = messageHandler
        self._isDismissed = isDismissed
    }
    
    public class Coordinator: NSObject, WKScriptMessageHandler {
        var parent: WebView
        
        public init(parent: WebView) {
            self.parent = parent
        }
        
        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if let messageBody = message.body as? String {
                print("Received message: \(messageBody)") // Debug log

                if let data = messageBody.data(using: .utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let action = json["action"] as? String,
                           let accountNumber = json["accountNumber"] as? String,
                           action == "dismiss" {
                            DispatchQueue.main.async {
                                // Pass the received message to the parent
                                self.parent.messageHandler.onMessageReceived("Account number: \(accountNumber)")
                                // Trigger dismissal
                                self.parent.isDismissed = nil
                            }
                        } else {
                            print("JSON format is invalid or missing keys.")
                        }
                    } catch {
                        print("Failed to parse JSON message: \(error.localizedDescription)")
                    }
                } else {
                    print("Message body could not be converted to data.")
                }
            } else {
                print("Message body is not a valid string.")
            }
        }
    }

    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        
        // Set up preferences for JavaScript
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true // Enable JavaScript for this navigation
        config.defaultWebpagePreferences = preferences
        
        // Set up message handler
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "iosHandler")
        config.userContentController = contentController
        
        // Create and return the WKWebView
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView finished loading")
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
