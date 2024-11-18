// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI
import SafariServices
import WebKit

public class WebViewIOSSDK {
    public init() {}
    
    /// Generic network call
    public func makeNetworkCall(url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            completion(.success(url)) // Simulating success
        }
    }
    
    /// Navigate to WebView or SafariView
    public func navigateToWebView(using url: URL, openInSafari: Bool, completion: @escaping (ViewType) -> Void) {
        guard UIApplication.shared.canOpenURL(url) else {
            print("Error: Cannot open URL \(url.absoluteString)")
            return
        }
        
        if openInSafari {
            print("Navigating to Safari with URL: \(url.absoluteString)")
            completion(.safari(url))
        } else {
            print("Navigating to WebView with URL: \(url.absoluteString)")
            completion(.web(url))
        }
    }
    
    /// Helper enum for view type
    public enum ViewType {
        case safari(URL)
        case web(URL)
    }
}

