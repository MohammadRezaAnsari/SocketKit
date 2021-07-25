//
//  Socket.swift
//  
//
//  Created by MohammadReza Ansary on 7/19/21.
//

import Foundation
import PusherSwift


struct JSONParser: Parser {
    var jsonDecoder: JSONDecoder {
        let decoder = Foundation.JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // The backend's default
        return decoder
    }
    func parseData<T: Decodable>(_ data: Data, to: T.Type) throws -> T { try jsonDecoder.decode(T.self, from: data) }
}


public protocol Parser {
    func parseData<T: Decodable>(_ data: Data, to: T.Type) throws -> T
}


//protocol MessageManager {
//    func subscribe<T: Hashable>(for visitId: String, handler: ((T) -> ()))
//    func send(event: Data, for visitId: String)
//}










protocol SocketManager {
    func establishSocket(_ key: String)
    func disbandSocket()
    func subscribe(_ name: String)
    func unsubscribe(_ name: String)
}

public protocol SocketDelegate: AnyObject {
    func subscribe<T: Codable>(for event: String, on channel: String, handler: @escaping (T) throws -> Void)
    func trigger<T: Codable>(for event: String, on channel: String, data: T)
}

public protocol SocketDatasource: AnyObject {
    func socketReturnJSONObject(in socket: Socket) -> Bool
    func socketAutoReconnect(in socket: Socket) -> Bool
    func socketActivityTimeout(in socket: Socket) -> Double
    func socketHostCluster(in socket: Socket) -> String
}


public class Socket {
    
    public static let `default`: Socket = {
        Socket()
    }()
    
    private var pusher: Pusher!
    private var channels: [PusherChannel] = []
    private var parser: Parser { JSONParser() }

    weak var datasource: SocketDatasource?
    
    
    private var authMethod: AuthMethod = {
        #if DEBUG
        return .inline(secret: "6cbdbeb15886107d0a0e")
        #else
        return .inline(secret: "")
        #endif
        
    }()
    
    private lazy var option: PusherClientOptions = {
        
        guard let datasource = datasource else {
            fatalError("Socket datasource is nil. first consider to setup `SocketDatasource`.")
        }
        
        return PusherClientOptions(authMethod: authMethod,
                                   attemptToReturnJSONObject: datasource.socketReturnJSONObject(in: self),
                                   autoReconnect: datasource.socketAutoReconnect(in: self),
                                   host: .cluster(datasource.socketHostCluster(in: self)),
                                   activityTimeout: datasource.socketActivityTimeout(in: self))
    }()
    
    private init() {}
}



// MARK: - Socket Manager
extension Socket: SocketManager {
    
    public func establishSocket(_ key: String) {
        pusher = Pusher.init(key: key, options: option)
        pusher.delegate = self
        pusher.connect()
    }
    
    public func disbandSocket() {
        pusher.disconnect()
    }
    
    public func subscribe(_ name: String) {
        guard channels.contains(where: { $0.name != name  }) else { return }
        let channel = pusher.subscribe(name)
        channels.append(channel)
    }
    
    public func unsubscribe(_ name: String) {
        guard channels.contains(where: { $0.name == name  }) else { return }
        pusher.unsubscribe(name)
        channels.removeAll(where: { $0.name == name })
    }
    
    public func unsubscribeAll() {
        pusher.unsubscribeAll()
        channels.removeAll()
    }
}


// MARK: - Socket Delegate
extension Socket: SocketDelegate {
    
    public func subscribe<T: Codable>(for event: String, on channel: String, handler: @escaping (T) throws -> Void) {
        
        guard let channel = channels.first(where: { $0.name == channel }) else {
            subscribe(channel)
            subscribe(for: event, on: channel, handler: handler)
            return
        }
        
        channel.bind(eventName: event) { event in
            
            guard let json: String = event.data, let jsonData: Data = json.data(using: .utf8) else {
                print("Could not convert JSON string to data")
                return
            }

            do {
                let result = try self.parser.parseData(jsonData, to: T.self)
                try handler(result)
            }
            catch let error {
                print(error)
            }
            
        }
    }
    
    public func trigger<T: Codable>(for event: String, on channel: String, data: T) {
        print("trigger event")
    }
}



// MARK: - Pusher Delegate
extension Socket: PusherDelegate {
    
    public func debugLog(message: String) {
        print("socket: \(message)")
    }

    public func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        print(old)
        print(new)
    }
    
    public func subscribedToChannel(name: String) {
        print("subscribe to channel successfully: \(name)")
    }
    
    public func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
        print("did failed subscribe to channel: \(name)")
        print(response)
        print(error)
    }
    
    public func failedToDecryptEvent(eventName: String, channelName: String, data: String?) {
        print("did failed to decrypt event: \(eventName)")
        print(channelName)
        print(data)
    }
    
    public func receivedError(error: PusherError) {
        print(error)
    }
}
