//
//  Swift+Extensions.swift
//  CallUI
//
//  Created by Mark Boleigha on 06/11/2022.
//  Copyright © 2022 Code HK. All rights reserved.
//

import Foundation

extension Encodable {
    var list: [String: Any]? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).map { $0 as? [String: Any] }!
    }
    
    var jsonData: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.keyEncodingStrategy = .useDefaultKeys
        guard let data = try? encoder.encode(self) else { return nil }
        return data
    }
}

extension Dictionary {
    func parse<T: Codable>(with: T.Type) throws -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: [.fragmentsAllowed, .prettyPrinted]) else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let obj = try? decoder.decode(T.self, from: data) else {
            return nil
        }
        return obj
    }
}
