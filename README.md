# SocketKit

[![Supported Platforms](https://img.shields.io/badge/platforms-iOS%20-333333.svg)](iOS)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)]()
[![Latest Release](https://img.shields.io/badge/Release-0.1.11-important)](https://github.com/MohammadRezaAnsari/SocketKit/releases)

[![Document](https://img.shields.io/badge/Docs-Pusher-blueviolet)](https://pusher.com/docs/channels/)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/MohammadRezaAnsari/SocketKit/blob/65327fa96c996485e54bea6b00fd8a2fdfbf874e/LICENSE)
[![Linkedin](https://img.shields.io/badge/linkedin-MohammadReza%20Ansary-blue)](https://www.linkedin.com/in/mohammadrezaansary)




## Supported platforms
- Swift 5.0 and above
- Xcode 12.0 and above
- Can be used with Objective-C


### Requirements
- iOS 13.0 and above



## Installation

### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler. It is in early development, but Alamofire does support its use on supported platforms.

Once you have your Swift package set up, adding `SocketKit` as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```bash
https://github.com/MohammadRezaAnsari/SocketKit
```

Alternatively, you can add SocketKit as a dependency in your `Package.swift` file. For example:

```swift
// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "PackageName",
    products: [
        .library(
            name: "PackageName",
            targets: ["YourPackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MohammadRezaAnsari/SocketKit", from: "0.1.11"),
    ],
    targets: [
        .target(
            name: "PackageName",
            dependencies: ["SocketKit"]),
    ]
)
```



## Pusher Channels overview

Pusher Channels provides realtime communication between servers, apps and devices. Channels is used for realtime charts, realtime user lists, realtime maps, multiplayer gaming, and many other kinds of UI updates.

When something happens in your system, it can update web-pages, apps and devices. When an event happens on an app, the app can notify all other apps and your system. For example, if the price of Bitcoin changes, your system could update the display of all open apps and web-pages. Or if Bob starts typing a message, his app could tell Alice’s app to display “Bob is typing …”.

Pusher Channels has libraries for everything: web browsers, iOS and Android apps, PHP frameworks, cloud functions, bash scripts, IoT devices. Pusher Channels works everywhere because it uses WebSockets and HTTP, and provides fallbacks for devices that don’t support WebSockets.


<p align="center">
<a href="" target="_blank"><img src="https://pusher.com/docs/static/img/hero_howitworks.png?branch=main" alt="Build Status" /></a>
</p>
