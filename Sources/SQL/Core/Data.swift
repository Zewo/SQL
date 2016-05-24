// Value.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Formbound
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

@_exported import C7



public struct OrderedDict<Key: Hashable, Val> : DictionaryLiteralConvertible {
    var elements: [(Key, Val?)]
    var keys: [Key] {
        return elements.map {$0.0}
    }
    var values: [Val?] {
        return elements.map {$0.1}
    }
    public init(dictionaryLiteral elements: (Key, Val?)...) {
        self.elements = elements
    }
    public init(elements: [(Key, Val?)]) {
        self.elements = elements
    }
    public subscript(key: Key) -> Val? {
        get {
            for (k,v) in elements {
                if key == k {
                    return v
                }
            }
            return nil
        }
        set(newValue) {
            elements.append((key, newValue))
        }
    }
}



public struct ValueConversionError: ErrorProtocol {
    let description: String
}

public enum SQLData {
    case Null
    case Text(String)
    case Binary(Data)
    case Query(QueryComponent)
}

extension SQLData: NilLiteralConvertible {
    public init(nilLiteral: ()) {
        self = .Null
    }
}

extension SQLData: QueryComponentRepresentable {
    public var queryComponent: QueryComponent {
        switch self {
        case .Text, Binary, Null:
            return .bind(data: self)
        case let .Query(query):
            return query
        }
    }
}

public protocol SQLDataRepresentable {
    var sqlData: SQLData { get }
}

public protocol SQLDataInitializable {
    init(rawSQLData: Data) throws
}

public protocol SQLDataConvertible: SQLDataRepresentable, SQLDataInitializable {
}


extension Int: SQLDataConvertible {
    public init(rawSQLData data: Data) throws {
        guard let value = Int(try String(data: data)) else {
            throw ValueConversionError(description: "Failed to convert data to Int")
        }
        self = value
    }

    public var sqlData: SQLData {
        return .Text(String(self))
    }
}

extension UInt: SQLDataConvertible {
    public init(rawSQLData data: Data) throws {
        guard let value = UInt(try String(data: data)) else {
            throw ValueConversionError(description: "Failed to convert data to UInt")
        }
        self = value
    }

    public var sqlData: SQLData {
        return .Text(String(self))
    }
}

extension Float: SQLDataConvertible {
    public init(rawSQLData data: Data) throws {
        guard let value = Float(try String(data: data)) else {
            throw ValueConversionError(description: "Failed to convert data to Float")
        }
        self = value
    }

    public var sqlData: SQLData {
        return .Text(String(self))
    }
}

extension Double: SQLDataConvertible {
    public init(rawSQLData data: Data) throws {
        guard let value = Double(try String(data: data)) else {
            throw ValueConversionError(description: "Failed to convert data to Double")
        }
        self = value
    }

    public var sqlData: SQLData {
        return .Text(String(self))
    }
}

extension String: SQLDataConvertible {
    public init(rawSQLData data: Data) throws {
        try self.init(data: data)
    }

    public var sqlData: SQLData {
        return .Text(self)
    }
}

extension Data: SQLDataConvertible {
    public init(rawSQLData data: Data) throws {
        self = data
    }

    public var sqlData: SQLData {
        return .Binary(self)
    }
}
