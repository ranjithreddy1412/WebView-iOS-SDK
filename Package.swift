// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "WebView-iOS-SDK",
    platforms: [
        .iOS(.v14) // Specify minimum platform version
    ],
    products: [
        // Define the library product
        .library(
            name: "WebView-iOS-SDK",
            targets: ["WebView-iOS-SDK"]
        )
    ],
    dependencies: [
        // Specify dependencies here if required
    ],
    targets: [
        // Define your main target
        .target(
            name: "WebView-iOS-SDK",
            path: "Sources/WebView-iOS-SDK",
            swiftSettings: [
                .define("ENABLE_SWIFTUI", .when(platforms: [.iOS], configuration: .release))
            ]
        ),
        // Define your test target
        .testTarget(
            name: "WebView-iOS-SDKTests",
            dependencies: ["WebView-iOS-SDK"]
        )
    ]
)

