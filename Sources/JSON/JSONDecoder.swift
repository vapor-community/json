import Foundation

public final class JSONDecoder<Type: JSONDecodable>: Decoder {
    public var codingPath: [CodingKey]
    public var userInfo: [CodingUserInfoKey : Any]
    private var data: JSONData

    public convenience init(data: Data) throws {
        var options: JSONSerialization.ReadingOptions = []
        options.insert(.allowFragments)
        let raw = try JSONSerialization.jsonObject(
            with: data,
            options: options
        )
        let json = JSONData(raw: raw)
        self.init(data: json)
    }

    init(data: JSONData, codingPath: [CodingKey] = []) {
        self.codingPath = codingPath
        self.userInfo = [:]
        self.data = data
    }

    func with<T>(pushedKey key: CodingKey, _ work: () throws -> T) rethrows -> T {
        self.codingPath.append(key)
        let ret: T = try work()
        self.codingPath.removeLast()
        return ret
    }

    public func container<Key>(
        keyedBy type: Key.Type
    ) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let cont = JSONContainer<Type, Key>(decoder: self, mode: .keyed, data: data)
        return KeyedDecodingContainer(cont)
    }

    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return JSONContainer<Type, ArrayKey>(decoder: self, mode: .unkeyed, data: data)
    }

    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return JSONContainer<Type, ArrayKey>(decoder: self, mode: .single, data: data)
    }
}

extension String: Error { }

struct ArrayKey {
    let index: Int

    init(index: Int) {
        self.index = index
    }
}

extension ArrayKey: CodingKey {
    var stringValue: String {
        return index.description
    }

    var intValue: Int? {
        return index
    }

    init?(intValue: Int) {
        fatalError("Not supported")
    }

    init?(stringValue: String) {
        fatalError("Not supported")
    }
}
