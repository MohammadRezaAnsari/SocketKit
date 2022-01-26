//
//  Socket.swift
//  
//
//  Created by MohammadReza Ansary on 7/19/21.
//
//  Linkedin: https://www.linkedin.com/in/mohammadrezaansary/
//  GitHub: https://github.com/MohammadRezaAnsari
//

import Foundation
import PusherSwift

public class Socket {
    
    public static let `default`: Socket = {
        Socket()
    }()
    
    private init() {
        delegate = self
    }
    
    
    private var pusher: Pusher!
    
    /// The delegate will be set whenever the socket did established.
    /// - Note: The delegate default value did set in the Socket initializer.
    public weak var delegate: PusherDelegate?
    
    
    /// Socket Options
    ///
    /// The options parameter on the Pusher constructor is an optional parameter used to apply configuration on a newly created Pusher instance.
    ///
    /// - Warning: If options are nil, establishing socket will throw `SocketError.emptyOption`
    /// - Note: Options conform `PusherClientOptions`
    public var options: Options?
    
    
    /// A parser for parsing event data
    /// ‌‌Base on your sever events data type choose and set the correct parser.
    /// - Note: parser default value is a `JSONParser`.
    public lazy var parser: Parser = { JSONParser() }()
}



// MARK: - Socket Base Methods
extension Socket {
    
    
    /// Establishing socket connection with specific key
    ///
    /// Initializing pusher and connect via key and options and set pusher delegate.
    ///
    /// - Parameter key: The application key is a string which is globally unique to your application. It can be found in the API Access section of your application within the Channels user dashboard.
    /// - Precondition: If options are nil, establishing socket will throw `SocketError.emptyOption`
    public final func establishSocket(_ key: String) throws {
        
        guard let options = options else { throw(SocketError.emptyOption) }
        
        pusher = Pusher.init(key: key, options: options.pusherClientOptions)
        pusher.delegate = delegate
        pusher.connect()
    }
    

    /// Easily disconnect from pusher
    /// - Note: All options and variables which have been set before will be remain.
    public final func disbandSocket() {
        unsubscribeAll()
        pusher.disconnect()
    }
    
    
    /// Unsubscribe all channels.
    /// - SeeAlso:  `disbandSocket()`
    public final func unsubscribeAll() {
        pusher.unsubscribeAll()
    }
    
    
    /// Subscribing to given channel name via pusher.
    ///
    /// - Parameter name: The name of the channel to subscribe to
    /// - Warning: If pusher contains a channel with the given name, it will throw `SocketError.channelExist`
    private func subscribe(_ name: String) throws {
        guard !pusher.connection.channels.channels.contains(where: { $0.key == name  }) else { throw(SocketError.channelExist) }
        _ = pusher.subscribe(name)
    }
    
    
    /// Unsubscribing to given channel name via pusher.
    ///
    /// - Parameter name: The name of the channel to unsubscribe to
    /// - Warning: If pusher NOT contains a channel with the given name, it will throw `SocketError.noChannel`
    private func unsubscribe(_ name: String) throws {
        guard pusher.connection.channels.channels.contains(where: { $0.key == name  }) else { throw(SocketError.noChannel) }
        pusher.unsubscribe(name)
    }
    
    
    
    /// Subscribe on the channel and bind receiving event to result.
    ///
    ///
    ///  ## Important ##
    ///  * Recursively subscribe to channel if the channel does not subscribe before, then it calls itself.
    ///
    /// - Parameter event: The name of the event to bind to
    /// - Parameter channel: The name of the channel to subscribe to
    /// - Parameter result: The return value of the method which is` Result<T: Codable, Error>` type
    open func subscribe<T: Codable>(for event: String, on channel: String, result: @escaping (Result<T, Error>) -> Void) {
        
        
        // Subscribing to channel
        guard let channel = pusher.connection.channels.channels.first(where: { $0.key == channel }) else {
            
            do {
                try subscribe(channel)
                subscribe(for: event, on: channel, result: result)
            }
            catch let error {
                assertionFailure("ForDebug: Logically it should not happen at all.")
                result(.failure(error as! SocketError))
            }
            return
        }
        
        
        // Binding event
        channel.value.bind(eventName: event) { event in
            
            guard let json: String = event.data, let jsonData: Data = json.data(using: .utf8) else {
                assertionFailure("ForDebug: Could not convert JSON string to data")
                return
            }
            
            do {
                let data = try self.parser.parseData(jsonData, to: T.self)
                result(.success(data))
            }
            catch let error {
                result(.failure(SocketError.parsingError(error)))
            }
        }
    }
    
    
    /// Trigger an event to given channel
    public func trigger<T: Codable>(for event: String, on channel: String, data: T) {
        print("ForDebug: The trigger is under develop.")
    }
}



// MARK: - Default Pusher Delegate
extension Socket: PusherDelegate {
    
    public func debugLog(message: String) {}
    public func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {}
    public func subscribedToChannel(name: String) {}
    public func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {}
    public func failedToDecryptEvent(eventName: String, channelName: String, data: String?) {}
    public func receivedError(error: PusherError) {}
}
