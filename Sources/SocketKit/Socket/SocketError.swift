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
}
