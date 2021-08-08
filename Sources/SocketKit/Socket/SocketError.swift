//
//  SocketError.swift
//  
//
//  Created by MohammadReza Ansary on 8/2/21.
//

public enum SocketError: Error {
    case emptyOption
    case channelExist
    case noChannel
    case parsingError(_ error: Error)
    
    public var message: String {
        switch self {
        case .emptyOption: return "There is no option."
        case .channelExist: return "The channel currently is subscribing."
        case .noChannel: return "There is no channel with given name."
        case .parsingError(let error): return "Parsing event data got error: \(error.localizedDescription)"
        }
    }
    
    public var localizedDescription: String {
        switch self {
        case .emptyOption: return "There is no option."
        case .channelExist: return "The channel currently is subscribing."
        case .noChannel: return "There is no channel with given name."
        case .parsingError(let error): return "Parsing event data got error: \(error.localizedDescription)"
        }
    }
}
