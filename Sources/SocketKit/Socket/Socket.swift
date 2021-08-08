//
//  Socket.swift
//  
//
//  Created by MohammadReza Ansary on 7/19/21.
//

import Foundation
import PusherSwift


protocol SocketManager {
    func establishSocket(_ key: String) throws
    func disbandSocket()
    func subscribe(_ name: String) throws
    func unsubscribe(_ name: String) throws
}

public class Socket {
    
    public static let `default`: Socket = {
        Socket()
    }()
    
    private var pusher: Pusher!
    private lazy var parser: Parser = { JSONParser() }()

    public var options: Options?
    
    private init() {}
}



// MARK: - Socket Manager
extension Socket: SocketManager {
    
    public func establishSocket(_ key: String) throws {
        guard let options = options else {
            throw(SocketError.emptyOption)
        }
        pusher = Pusher.init(key: key, options: options.pusherClientOptions)
        pusher.delegate = self
        pusher.connect()
    }
    
    public func disbandSocket() {
        pusher.disconnect()
    }
    
    public func subscribe(_ name: String) throws {
        guard pusher.connection.channels.channels.contains(where: { $0.key != name  }) else {
            throw(SocketError.channelExist)
        }
        _ = pusher.subscribe(name)
    }
    
    public func unsubscribe(_ name: String) throws {
        guard pusher.connection.channels.channels.contains(where: { $0.key == name  }) else {
            throw(SocketError.noChannel)
        }
        pusher.unsubscribe(name)
    }
    
    public func unsubscribeAll() {
        pusher.unsubscribeAll()
    }
}


// MARK: - Socket Function
extension Socket {
    
    public func subscribe<T: Codable>(for event: String, on channel: String, handler: @escaping (Result<T, Error>) -> Void) {
        
        guard let channel = pusher.connection.channels.channels.first(where: { $0.key == channel }) else {
            
            do {
                try subscribe(channel)
                subscribe(for: event, on: channel, handler: handler)
            } catch let error {
                handler(.failure(error as! SocketError))
            }
            
            return
        }
        
        
        channel.value.bind(eventName: event) { event in
            
            guard let json: String = event.data, let jsonData: Data = json.data(using: .utf8) else {
                print("Could not convert JSON string to data")
                return
            }
            
            do {
                let result = try self.parser.parseData(jsonData, to: T.self)
                handler(.success(result))
            }
            catch let error {
                handler(.failure(SocketError.parsingError(error)))
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
        print("Debug Socket: \(message)")
    }
    
    public func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        print("Debug Socket: old state: \(old)")
        print("Debug Socket: new state: \(new)")
    }
    
    public func subscribedToChannel(name: String) {
        print("Debug Socket: subscribe to channel successfully: \(name)")
    }
    
    public func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
        print("Debug Socket: did failed subscribe to channel: \(name)")
        print("Debug Socket: response is \(String(describing: response))")
        print("Debug Socket: error is \(String(describing: error))")
    }
    
    public func failedToDecryptEvent(eventName: String, channelName: String, data: String?) {
        print("Debug Socket: did failed to decrypt event with name \(eventName)")
        print("Debug Socket: channel name is \(channelName)")
        print("Debug Socket: date is \(String(describing: data))")
    }
    
    public func receivedError(error: PusherError) {
        print("Debug Socket: received error - \(error)")
    }
}
