internal final class JSONContainer<
    Type: JSONDecodable, K: CodingKey
>: UnkeyedDecodingContainer, SingleValueDecodingContainer, KeyedDecodingContainerProtocol {
    typealias Key = K
    enum Mode { case single, keyed, unkeyed }

    var decoder: JSONDecoder<Type>
    var currentIndex: Int
    var mode: Mode
    var data: JSONData

    init(decoder: JSONDecoder<Type>, mode: Mode, data: JSONData) {
        self.decoder = decoder
        self.mode = mode
        self.currentIndex = 0
        self.data = data
    }

    // MARK: Get

    func assertGet<K: CodingKey>(key: K) throws -> JSONData {
        guard let container = get(key: key) else {
            throw "key doesn't exist: '\(key)': '\(codingPath)'"
        }
        return container
    }

    func get<K: CodingKey>(key: K) -> JSONData? {
        let key = Type.jsonKeyMap(key: key)
        return data.dictionary?[key]
    }

    // MARK: Computed

    var allKeys: [K] {
        return data.dictionary?.keys.flatMap {
            Key(stringValue: $0)
        } ?? []
    }

    var codingPath: [CodingKey] {
        return decoder.codingPath
    }

    var count: Int? {
        return data.array?.count
    }

    var isAtEnd: Bool {
        guard let count = count else {
            return true
        }

        return currentIndex >= count
    }

    func contains(_ key: K) -> Bool {
        return allKeys.contains(where: { $0.stringValue == key.stringValue })
    }

    // MARK: Nested

    func nestedContainer<NestedKey>(
        keyedBy type: NestedKey.Type
    ) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        let key = ArrayKey(index: currentIndex)
        return try decoder.with(pushedKey: key) {
            let data = try self.data.assertArray()[currentIndex]
            currentIndex += 1
            let cont = JSONContainer<Type, NestedKey>(decoder: decoder, mode: .keyed, data: data)
            return KeyedDecodingContainer(cont)
        }
    }

    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        let key = ArrayKey(index: currentIndex)
        return try decoder.with(pushedKey: key) {
            let data = try self.data.assertArray()[currentIndex]
            return JSONContainer<Type, Key>(decoder: decoder, mode: .unkeyed, data: data)
        }
    }

    func nestedContainer<NestedKey>(
        keyedBy type: NestedKey.Type,
        forKey key: K
    ) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        return try decoder.with(pushedKey: key) {

            let data = try assertGet(key: key)
            let cont = JSONContainer<Type, NestedKey>(decoder: decoder, mode: .keyed, data: data)
            return KeyedDecodingContainer(cont)
        }
    }

    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        return try decoder.with(pushedKey: key) {
            let data = try assertGet(key: key)
            return JSONContainer(decoder: decoder, mode: .unkeyed, data: data)
        }
    }

    // MARK: Super

    func superDecoder(forKey key: K) throws -> Decoder {
        return try decoder.with(pushedKey: key) {
            let data = try assertGet(key: key)
            return JSONDecoder<Type>(data: data, codingPath: decoder.codingPath)
        }
    }

    func superDecoder() throws -> Decoder {
        let key = ArrayKey(index: currentIndex)
        return try decoder.with(pushedKey: key) {
            let data = try self.data.assertArray()[currentIndex]
            currentIndex += 1
            return JSONDecoder<Type>(data: data, codingPath: decoder.codingPath)
        }
    }

    // MARK: Decode Unkeyed / Single

    func decodeNil() -> Bool { return data.isNull }
    func decode(_ type: Bool.Type) throws -> Bool { return try data.assertBool() }
    func decode(_ type: Int.Type) throws -> Int { return try data.assertInt() }
    func decode(_ type: Int8.Type) throws -> Int8 { return try data.assertInt8() }
    func decode(_ type: Int16.Type) throws -> Int16 { return try data.assertInt16() }
    func decode(_ type: Int32.Type) throws -> Int32 { return try data.assertInt32() }
    func decode(_ type: Int64.Type) throws -> Int64 { return try data.assertInt64() }
    func decode(_ type: UInt.Type) throws -> UInt { return try data.assertUInt() }
    func decode(_ type: UInt8.Type) throws -> UInt8 { return try data.assertUInt8() }
    func decode(_ type: UInt16.Type) throws -> UInt16 { return try data.assertUInt16() }
    func decode(_ type: UInt32.Type) throws -> UInt32 { return try data.assertUInt32() }
    func decode(_ type: UInt64.Type) throws -> UInt64 { return try data.assertUInt64() }
    func decode(_ type: Float.Type) throws -> Float { return try data.assertFloat() }
    func decode(_ type: Double.Type) throws -> Double { return try data.assertDouble() }
    func decode(_ type: String.Type) throws -> String { return try data.assertString() }
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable { return try T(from: decoder) }

    // MARK: Decode Keyed

    func decodeNil(forKey key: K) throws -> Bool { return get(key: key)?.isNull ?? true }
    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool { return try assertGet(key: key).assertBool() }
    func decode(_ type: Int.Type, forKey key: K) throws -> Int { return try assertGet(key: key).assertInt() }
    func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 { return try assertGet(key: key).assertInt8() }
    func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 { return try assertGet(key: key).assertInt16() }
    func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 { return try assertGet(key: key).assertInt32() }
    func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 { return try assertGet(key: key).assertInt64() }
    func decode(_ type: UInt.Type, forKey key: K) throws -> UInt { return try assertGet(key: key).assertUInt() }
    func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 { return try assertGet(key: key).assertUInt8() }
    func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 { return try assertGet(key: key).assertUInt16() }
    func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 { return try assertGet(key: key).assertUInt32() }
    func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 { return try assertGet(key: key).assertUInt64() }
    func decode(_ type: Float.Type, forKey key: K) throws -> Float { return try assertGet(key: key).assertFloat() }
    func decode(_ type: Double.Type, forKey key: K) throws -> Double { return try assertGet(key: key).assertDouble() }
    func decode(_ type: String.Type, forKey key: K) throws -> String { return try assertGet(key: key).assertString() }

    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T : Decodable {
        return try decoder.with(pushedKey: key) {
            let data = try assertGet(key: key)
            let decoder = JSONDecoder<Type>(data: data, codingPath: self.decoder.codingPath)
            return try T(from: decoder)
        }
    }
}

