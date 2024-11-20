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
    
    public init(url: URL, messageHandler: WebViewMessageHandler) {
        self.url = url
        self.messageHandler = messageHandler
    }
    
    public class Coordinator: NSObject, WKScriptMessageHandler {
        var parent: WebView
        
        public init(parent: WebView) {
            self.parent = parent
        }
        
        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if let messageBody = message.body as? String {
                parent.messageHandler.onMessageReceived(messageBody)
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "iosHandler")
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}



