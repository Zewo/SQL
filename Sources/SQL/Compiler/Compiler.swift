
public class Compiler {

    func compile(_ field: Field) -> String {
        switch field {
        case let .column(column):
                    var stringParts: [String] = []
                    if let table = column.tableName {
                        stringParts.append("\(table).\(column.name)")
                    } else {
                        stringParts.append(column.name)
                    }
                    if let alias = column.aliasName {
                        stringParts.append(contentsOf: ["as", alias])
                    }
                    return stringParts.joined(separator: " ")
        case let .subquery(subquery):
            return compile(subquery)
        }
    }
    
    func compile(_ subquery: Subquery) -> String {
        return "subquery"
    }
    
    func compile(_ select: Select) -> String {
        var components = [String]()
        
        components.append("SELECT")
        
        var fieldComponents = [String]()
        
        for field in select.fields {
            fieldComponents.append(compile(field))
        }
        
        components.append(fieldComponents.joined(separator: ", "))
        components.append("FROM")
        
        
        var sourceComponents = [String]()
        
        components.append(compile(select.source))
//        for source in select.from {
//            switch source {
//            case .string(let string):
//                sourceComponents.append(string)
//                break
//            case .subquery(let subquery, alias: let alias):
//                sourceComponents.append("\(composeStatement(subquery)) as \(alias)")
//            case .field(let field):
//                sourceComponents.append(field.sqlString)
//            }
//        }
//        
//        components.append(sourceComponents.joined(separator: ", "))
//        
//        if !select.joins.isEmpty {
//            components.append(select.joins.sqlStringJoined(separator: " "))
//        }
//        
//        if let predicate = select.predicate {
//            components.append("WHERE")
//            components.append(predicate.sqlString)
//        }
//        
//        if !select.order.isEmpty {
//            components.append(select.order.sqlStringJoined(separator: ", "))
//        }
//        
        if let limit = select.limit {
            components.append("LIMIT \(limit)")
        }
        
        if let offset = select.offset {
            components.append("OFFSET \(offset)")
        }
        
        return components.joined(separator: " ")
    }
//    var sqlData: [SQLData] = []
//
//    
//    func column(name: String, table: String?, alias: String?) -> [String] {
//        var stringParts: [String] = []
//        if let table = table {
//            stringParts.append("\(table).\(name)")
//        } else {
//            stringParts.append(name)
//        }
//        if let alias = alias {
//            stringParts.append(contentsOf: ["as", alias])
//        }
//        return stringParts
//    }
//
//    func table(name: String, alias: String?) -> [String] {
//        var stringParts = [name, ]
//        if let alias = alias {
//            stringParts.append(contentsOf: ["AS", alias])
//        }
//        return stringParts
//    }
//
//    func bind(_ data: SQLData) -> [String] {
//        if case .Null = data {
//            return ["NULL"]
//        }
//        sqlData.append(data)
//        return ["%s"]
//    }
//
//    func joinType(_ type: Join.JoinType) -> String {
//        switch type {
//        case .Inner:
//            return "INNER"
//        case .Left:
//            return "LEFT"
//        case .Outer:
//            return "OUTER"
//        case .Right:
//            return "RIGHT"
//        }
//    }
//
//    func join(types: [Join.JoinType], with: QueryComponent, leftKey: QueryComponent, rightKey: QueryComponent) -> [String] {
//        var stringParts: [String] = []
//        stringParts.append(contentsOf: types.map {
//            joinType($0)
//        })
//        stringParts.append("JOIN")
//        stringParts.append(contentsOf: compilePart(with))
//        stringParts.append("ON")
//        stringParts.append(contentsOf: compilePart(leftKey))
//        stringParts.append("=")
//        stringParts.append(contentsOf: compilePart(rightKey))
//        return stringParts
//    }
//
//    func subquery(query: QueryComponent, alias: String?) -> [String] {
//        var stringParts: [String] = ["("]
//        stringParts.append(contentsOf: compilePart(query))
//        stringParts.append(")")
//        if let alias = alias {
//            stringParts.append(contentsOf: ["AS", alias])
//        }
//        return stringParts
//    }
//
//    func select(fields: [QueryComponent], from: QueryComponent, joins: [QueryComponent],
//                filter: QueryComponent?, ordersBy: [QueryComponent], offset: QueryComponent?,
//                limit: QueryComponent?, groupBy: QueryComponent?, having: QueryComponent?) -> [String] {
//
//
//        var stringParts = ["SELECT"]
//        if fields.isEmpty {
//            stringParts.append("*")
//        } else {
//            let fieldParts = fields.map{ compilePart($0) }.joined(separator: [","])
//            stringParts.append(contentsOf: fieldParts)
//        }
//
//        stringParts.append("FROM")
//        stringParts.append(contentsOf: compilePart(from))
//
//        for join in joins {
//            stringParts.append(contentsOf: compilePart(join))
//        }
//
//        if let filter = filter {
//            stringParts.append("WHERE")
//            stringParts.append(contentsOf: compilePart(filter))
//        }
//        
//        if !ordersBy.isEmpty {
//            stringParts.append("ORDER BY")
//            let ordersParts = ordersBy.map { compilePart($0) }.joined(separator: [","])
//            stringParts.append(contentsOf: ordersParts)
//
//        }
//        
//        if (offset != nil || limit != nil) {
//            stringParts = offsetLimit(selectQuery: stringParts, offset: offset, limit: limit)
//        }
//        
//        if let groupBy = groupBy {
//            stringParts.append(contentsOf: compilePart(groupBy))
//        }
//
//        return stringParts
//    }
//
//    func orderBy(_ field: OrderBy) -> [String] {
//        switch field {
//        case let .Ascending(column):
//            return compilePart(column.queryComponent) + ["ASC"]
//        case let .Descending(column):
//            return compilePart(column.queryComponent) + ["DESC"]
//        }
//
//    }
//    func compileCondition(_ condition: Condition) -> [String] {
//        func statementWithKeyValue(_ key: QueryComponentRepresentable, _ op: String, _ value: QueryComponentRepresentable) -> [String] {
//            var stringParts: [String] = []
//            stringParts.append(contentsOf: compilePart(key.queryComponent))
//            stringParts.append(op)
//            stringParts.append(contentsOf: compilePart(value.queryComponent))
//            return stringParts
//        }
//
//        switch condition {
//        case .Equals(let key, let value):
//            return statementWithKeyValue(key, "=", value)
//
//        case .GreaterThan(let key, let value):
//            return statementWithKeyValue(key, ">", value)
//
//        case .GreaterThanOrEquals(let key, let value):
//            return statementWithKeyValue(key, ">=", value)
//
//        case .LessThan(let key, let value):
//            return statementWithKeyValue(key, "<", value)
//
//        case .LessThanOrEquals(let key, let value):
//            return statementWithKeyValue(key, "<=", value)
//
//        case let .Is(key, value):
//            return statementWithKeyValue(key, "IS", value)
//
////        case .In(let key, let values):
////
////            var strings = [String]()
////
////            for _ in values {
////                strings.append(queryComponent.valuePlaceholder)
////            }
////
////            return queryComponent("\(key) IN(\(strings.joined(separator: ", ")))", values: values)
////
////        case .NotIn(let key, let values):
////            return (!Condition.In(key, values)).queryComponent
//
//        case .And(let conditions):
//            var stringParts = ["("]
//            let condParts: [[String]] = conditions.map {compileCondition($0)}
//            stringParts.append(contentsOf: condParts.joined(separator: ["AND"]))
//            stringParts.append(")")
//            return stringParts
//
//        case .Or(let conditions):
//            var stringParts = ["("]
//            let condParts: [[String]] = conditions.map {compileCondition($0)}
//            stringParts.append(contentsOf: condParts.joined(separator: ["OR"]))
//            stringParts.append(")")
//            return stringParts
//        case .Not(let cond):
//            var stringParts = ["NOT", "("]
//            stringParts.append(contentsOf: compileCondition(cond))
//            stringParts.append(")")
//
//            return stringParts
//        default:
//            return []
////        case .Like(let key, let value):
////            return queryComponent(strings: [key.qualifiedName, "LIKE", queryComponent.valuePlaceholder], values: [value])
//        }
//    }
//
//    func offsetLimit(selectQuery: [String], offset: QueryComponent?, limit: QueryComponent?) -> [String] {
//        var stringParts = selectQuery
//        if case let .limit(num)? = limit {
//            stringParts.append("LIMIT \(num)")
//        }
//        if case let .offset(num)? = offset {
//            stringParts.append("OFFSET \(num)")
//        }
//        return stringParts
//
//    }
//
//
//
//    func compile(fields: GroupBy) -> [String] {
//        var stringParts = ["GROUP BY"]
//        let fieldParts = fields.map{ compilePart($0) }.joined(separator: [","])
//
//        stringParts.append(contentsOf: fieldParts)
//        return stringParts
//    }
//
//    func delete(from: QueryComponent, condition: QueryComponent?) -> [String] {
//        var stringParts = ["DELETE FROM"]
//        stringParts.append(contentsOf: compilePart(from))
//        if let condition = condition {
//            stringParts.append("WHERE")
//            stringParts.append(contentsOf: compilePart(condition))
//        }
//        return stringParts
//    }
//    func insert(into: QueryComponent, values: ValuesList, returning: [QueryComponent]) -> [String] {
//        var stringParts = ["INSERT INTO"]
//        stringParts.append(contentsOf: compilePart(into))
//        stringParts.append("(")
//        let columnsParts = values.keys.map { (field: DeclaredField) -> [String] in
//            var field = field
//            field.tableName = nil
//            return self.compilePart(field.queryComponent)
//        }.joined(separator: [","])
//        
//        stringParts.append(contentsOf: columnsParts )
//        stringParts.append(contentsOf: [")", "VALUES", "("])
//        let valuesParts = values.values.map{ self.compilePart(($0?.sqlData ?? .Null ).queryComponent) }.joined(separator: [","])
//        stringParts.append(contentsOf: valuesParts)
//        stringParts.append(")")
//        if !returning.isEmpty {
//            stringParts.append(contentsOf: renderReturning(returning))
//        }
//        return stringParts
//    }
//
//    func renderReturning(_ fields: [QueryComponent]) -> [String] {
//        var stringParts = ["RETURNING"]
//        let fieldParts = fields.map{ compilePart($0) }.joined(separator: [","])
//        stringParts.append(contentsOf: fieldParts)
//        return stringParts
//    }
//
//    func update(table: QueryComponent, set: ValuesList, condition: QueryComponent?) -> [String] {
//        var stringParts = ["UPDATE"]
//        stringParts.append(contentsOf: compilePart(table))
//        stringParts.append("SET")
//        let components: [QueryComponent] = set.elements.map { .parts([ $0.0.queryComponent, "=", ($0.1?.sqlData ?? .Null).queryComponent ]) }
//        let valuesParts = components.map{ compilePart($0) }.joined(separator: [","])
//        stringParts.append(contentsOf: valuesParts)
//        if let condition = condition {
//            stringParts.append("WHERE")
//            stringParts.append(contentsOf: compilePart(condition))
//        }
//        return stringParts
//    }

}