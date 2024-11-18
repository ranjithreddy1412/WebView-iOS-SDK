//
//  File.swift
//  WebView-iOS-SDK
//
//  Created by ranjith kumar reddy b perkampally on 11/18/24.
//

import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {
    let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}



