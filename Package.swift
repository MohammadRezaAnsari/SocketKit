// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SocketKit",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SocketKit",
            targets: ["SocketKit"]),
    ],
    dependencies: [
        .package(name: "PusherSwift" ,url: "https://github.com/pusher/pusher-websocket-swift.git", from: "10.0.0"),
    ],
    targets: [
        .target(
            name: "SocketKit",
            dependencies: [
                "PusherSwift",
            ]),
        .testTarget(
            name: "SocketKitTests",
            dependencies: ["SocketKit"]),
    ]
)
