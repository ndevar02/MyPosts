//
//  Data.swift
//  myPostsTests
//
//  Created by Nithya Devarajan on 07/01/22.
//

import Foundation
public extension Data {

    public func jsonSerialized() -> Data? {
        guard let json = try? JSONSerialization.jsonObject(with: self) else {
            return nil
        }
        let object: Any = {
            if let array = json as? Array<Any> {
                return array.strippingNulls()
            } else if let dictionary = json as? Dictionary<String, Any> {
                return dictionary.strippingNulls()
            } else {
                return json
            }
        }()
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: [.sortedKeys, .prettyPrinted]) else {
            return nil
        }
        return data
    }

    public static func jsonMismatch(lhs: Data, rhs: Data, alreadySerialized: Bool = false) -> Int? {
        switch alreadySerialized {
        case true:
            return _jsonMismatch(lhs: lhs, rhs: rhs)
        case false:
            guard let lhs = lhs.jsonSerialized(), let rhs = rhs.jsonSerialized() else {
                return nil
            }
            return _jsonMismatch(lhs: lhs, rhs: rhs)
        }
    }

    private static func _jsonMismatch(lhs: Data, rhs: Data) -> Int? {
        guard let string1 = String(data: lhs, encoding: .utf8), let string2 = String(data: rhs, encoding: .utf8) else {
            return nil
        }
        let components1 = string1.components(separatedBy: "\n")
        let components2 = string2.components(separatedBy: "\n")
        let count = components1.count < components2.count ? components1.count : components2.count
        for index in 0 ..< count {
            if components1[index] != components2[index] {
                return index
            }
        }
        return nil
    }
}

private extension Array where Element == Any {

    func strippingNulls() -> Array {
        var array = self
        array.stripNulls()
        return array
    }

    mutating func stripNulls() {
        let count = self.count
        guard count > 0 else {
            return
        }
        for _index in 0 ..< count {
            let index = count - 1 - _index
            if self[index] is NSNull {
                remove(at: index)
            } else if let array = self[index] as? [Any] {
                self[index] = array.strippingNulls()
            } else if let dictionary = self[index] as? [String: Any] {
                self[index] = dictionary.strippingNulls()
            }
        }
    }
}

private extension Dictionary where Key == String, Value == Any {

    func strippingNulls() -> Dictionary {
        var dictionary = self
        dictionary.stripNulls()
        return dictionary
    }

    mutating func stripNulls() {
        for (key, value) in self {
            if value is NSNull {
                removeValue(forKey: key)
            } else if let array = value as? [Any] {
                self[key] = array.strippingNulls()
            } else if let dictionary = value as? [String: Any] {
                self[key] = dictionary.strippingNulls()
            }
        }
    }
}
