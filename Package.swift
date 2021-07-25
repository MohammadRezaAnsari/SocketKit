// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ServiceKit",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "ServiceKit",
            targets: ["ServiceKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0"))
    ],
    targets: [
        .target(
            name: "ServiceKit",
            dependencies: ["Alamofire"]),
        .testTarget(
            name: "ServiceKitTests",
            dependencies: ["ServiceKit"]),
    ]
)
