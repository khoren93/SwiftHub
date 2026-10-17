//
//  Codable+SwiftHub.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 10/18/26.
//  Copyright © 2026 Khoren Markosyan. All rights reserved.
//

import Foundation

/// JSON key given as a string, so models map their fields by name: `fullname = map["full_name"]`
struct JSONKey: CodingKey {
    let stringValue: String
    let intValue: Int? = nil

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }
}

extension KeyedDecodingContainer where Key == JSONKey {

    /// Value at a key or a dotted key path, e.g. "parent.full_name".
    /// Missing, null and mistyped values are nil, so one unexpected field doesn't fail the whole model.
    subscript<T: Decodable>(_ keyPath: String) -> T? {
        var keys = keyPath.components(separatedBy: ".")
        let lastKey = JSONKey(stringValue: keys.removeLast())
        var container = self
        for key in keys {
            guard let nested = try? container.nestedContainer(keyedBy: JSONKey.self, forKey: JSONKey(stringValue: key)) else { return nil }
            container = nested
        }
        return try? container.decodeIfPresent(T.self, forKey: lastKey)
    }
}

extension KeyedEncodingContainer where Key == JSONKey {

    mutating func encode<T: Encodable>(_ value: T?, forKey key: String) throws {
        try encodeIfPresent(value, forKey: JSONKey(stringValue: key))
    }
}

extension JSONDecoder {

    /// Decoder for GitHub API responses and stored models
    static let swiftHub: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let string = try decoder.singleValueContainer().decode(String.self)
            guard let date = string.toISODate() else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid ISO 8601 date: \(string)"))
            }
            return date
        }
        return decoder
    }()
}

extension JSONEncoder {

    /// Encoder for stored models
    static let swiftHub: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
}

extension Decodable {

    /// Decodes a model stored as a JSON string
    init?(jsonString: String) {
        guard let model = try? JSONDecoder.swiftHub.decode(Self.self, from: Data(jsonString.utf8)) else { return nil }
        self = model
    }
}

extension Encodable {

    /// Encodes the model as a JSON string for storage
    func jsonString() -> String? {
        guard let data = try? JSONEncoder.swiftHub.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
