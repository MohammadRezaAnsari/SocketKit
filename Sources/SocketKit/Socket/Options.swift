//
//  Options.swift
//  
//
//  Created by MohammadReza Ansary on 8/2/21.
//

import Foundation
import PusherSwift

public protocol Options {
    var authMethod: AuthMethod { get set }
    var attemptToReturnJSONObject: Bool { get }
    var autoReconnect: Bool { get }
    var host: String { get }
    var port: Int { get }
    var path: String? { get }
    var useTLS: Bool { get }
    var activityTimeout: TimeInterval? { get }
}

public extension Options {
    var authMethod: AuthMethod {
        #if DEBUG
        return .inline(secret: "6cbdbeb15886107d0a0e")
        #else
        return .inline(secret: "")
        #endif
    }
}

extension PusherClientOptions: Options { }

extension Options {
    var pusherClientOptions: PusherClientOptions {
        .init(
            authMethod: authMethod,
            attemptToReturnJSONObject: attemptToReturnJSONObject,
            autoReconnect: autoReconnect,
            host: PusherHost.cluster(host),
            port: port,
            path: path,
            useTLS: useTLS,
            activityTimeout: activityTimeout
        )
    }
}
