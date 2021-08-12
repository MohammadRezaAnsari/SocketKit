//
//  Parser.swift
//  
//
//  Created by MohammadReza Ansary on 8/2/21.
//
//  Linkedin: https://www.linkedin.com/in/mohammadrezaansary/
//  GitHub: https://github.com/MohammadRezaAnsari
//

import Foundation

public protocol Parser {
    func parseData<T: Decodable>(_ data: Data, to: T.Type) throws -> T
}

struct JSONParser: Parser {
    var jsonDecoder: JSONDecoder {
        let decoder = Foundation.JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    func parseData<T: Decodable>(_ data: Data, to: T.Type) throws -> T { try jsonDecoder.decode(T.self, from: data) }
}
