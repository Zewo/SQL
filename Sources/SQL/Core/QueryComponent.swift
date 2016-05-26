// queryComponent.swift
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


public indirect enum QueryComponent {
    case join(types:[Join.JoinType], with:QueryComponent, leftKey:QueryComponent, rightKey:QueryComponent)
    case parts([QueryComponent])
    case select(fields:[QueryComponent], from:QueryComponent, joins:[QueryComponent],
                filter:QueryComponent?, ordersBy:[QueryComponent], offset:QueryComponent?,
                limit:QueryComponent?, groupBy:QueryComponent?, having:QueryComponent?)

    case subquery(query:QueryComponent, alias:String?)
    case table(name:String, alias:String?)
    case column(name:String, table:String?, alias:String?)
    case set(values:QueryComponent)
    case function(name:String, args:QueryComponent)
    case condition(condition: Condition)
    case bind(data: SQLData)
//    case and(left: QueryComponent, right: QueryComponent)
//    case or(left: QueryComponent, right: QueryComponent)
    case orderBy(orderBy: OrderBy)
    case groupBy(fields:[QueryComponent])
    case having(parts:QueryComponent)
    case offset(Int)
    case limit(Int)
    case delete(from: QueryComponent, filter: QueryComponent?)
    case insert(into: QueryComponent, values: ValuesList, returning: [QueryComponent])
    case update(table: QueryComponent, set: ValuesList, filter: QueryComponent?)
    case sql(String)
    case caseClause

}


extension QueryComponent: StringLiteralConvertible {
    public init(stringLiteral value: String) {
        self = .sql(value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension QueryComponent: ArrayLiteralConvertible {
    public init(arrayLiteral elements: QueryComponent...) {
        self = .parts(elements)
    }
}

public protocol QueryComponentRepresentable {
//    var queryComponent: QueryComponent { get }
}


//public extension Sequence where Iterator.Element: QueryComponentRepresentable {
//    public func queryComponent(mergedByString string: String? = nil) -> queryComponent {
//        return queryComponent(components: self.map { $0.queryComponent }, mergedByString: string)
//    }
//
//    public var queryComponent: queryComponent {
//        return queryComponent()
//    }
//}
//
//

//extension String: QueryComponentRepresentable {
//    public var queryComponent: QueryComponent {
//        return .sql(self)
//    }
//}

//
//
//extension queryComponent: StringInterpolationConvertible {
//    public init(stringInterpolation strings: queryComponent...) {
//        self.init(components: strings)
//    }
//    public init(stringInterpolationSegment expr: queryComponent) {
//        self = expr
//    }
//    public init(stringInterpolationSegment expr: String) {
//        self = queryComponent(expr)
//    }
//
//    public init<T: QueryComponentRepresentable>(stringInterpolationSegment expr: T) {
//        print(expr)
//        self = expr.queryComponent
//    }
//    public init<T: CustomStringConvertible>(stringInterpolationSegment expr: T) {
//        print(expr)
//        self = queryComponent(String(expr))
//    }
//    public init<T>(stringInterpolationSegment expr: T) {
//        print(expr)
//        self = queryComponent(String(expr))
//    }
//}
//
