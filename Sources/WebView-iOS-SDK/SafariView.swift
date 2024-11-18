//
//  File.swift
//  WebView-iOS-SDK
//
//  Created by ranjith kumar reddy b perkampally on 11/18/24.
//

import SwiftUI
import SafariServices

// SafariView
public struct SafariView: UIViewControllerRepresentable {
    let url: URL

    public init(url: URL) {
        self.url = url
    }

    public func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
