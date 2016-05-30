//
//  Parameter.swift
//  SQL
//
//  Created by David Ask on 23/05/16.
//
//

public indirect enum Predicate {
    case expression(left: Parameter, operator: Operator, right: Parameter)
    case and([Predicate])
    case or([Predicate])
    case not(Predicate)
}

extension Predicate: StatementParameterListConvertible {
    public var sqlParameters: [Value?] {
        switch self {
        case .expression(let left, _, let right):
            return left.sqlParameters + right.sqlParameters
        case .and(let predicates):
            return predicates.flatMap { $0.sqlParameters }
        case .or(let predicates):
            return predicates.flatMap { $0.sqlParameters }
        case .not(let predicate):
            return predicate.sqlParameters
        }
    }
}

public prefix func ! (predicate: Predicate) -> Predicate {
    return .not(predicate)
}


public func == (lhs: ParameterConvertible?, rhs: ParameterConvertible?) -> Predicate {
    return .expression(left: lhs?.sqlParameter ?? .null, operator: .equal, right: rhs?.sqlParameter ?? .null)
}

public func > (lhs: ParameterConvertible?, rhs: ParameterConvertible?) -> Predicate {
    return .expression(left: lhs?.sqlParameter ?? .null, operator: .greaterThan, right: rhs?.sqlParameter ?? .null)
}

public func < (lhs: ParameterConvertible?, rhs: ParameterConvertible?) -> Predicate {
    return .expression(left: lhs?.sqlParameter ?? .null, operator: .lessThan, right: rhs?.sqlParameter ?? .null)
}

public func >= (lhs: ParameterConvertible?, rhs: ParameterConvertible?) -> Predicate {
    return .expression(left: lhs?.sqlParameter ?? .null, operator: .greaterThanOrEqual, right: rhs?.sqlParameter ?? .null)
}

public func <= (lhs: ParameterConvertible?, rhs: ParameterConvertible?) -> Predicate {
    return .expression(left: lhs?.sqlParameter ?? .null, operator: .lessThanOrEqual, right: rhs?.sqlParameter ?? .null)
}

// Contains

extension ParameterConvertible {
    public func contains(_ values: [ValueConvertible?]) -> Predicate {
        return contains(values.map { $0?.sqlValue })
    }
    
    public func contains(_ values: ValueConvertible?...) -> Predicate {
        return contains(values)
    }
    
    public func contains(_ values: [Value?]) -> Predicate {
        return .expression(left: self.sqlParameter, operator: .contains, right: .values(values))
    }
    
    public func contains(_ values: Value?...) -> Predicate {
        return contains(values)
    }
}

// Contains

extension ParameterConvertible {
    public func containedIn(_ values: [ValueConvertible?]) -> Predicate {
        return containedIn(values.map { $0?.sqlValue })
    }
    
    public func containedIn(_ values: ValueConvertible?...) -> Predicate {
        return containedIn(values)
    }
    
    public func containedIn(_ values: [Value?]) -> Predicate {
        return .expression(left: self.sqlParameter, operator: .containedIn, right: .values(values))
    }
    
    public func containedIn(_ values: Value?...) -> Predicate {
        return containedIn(values)
    }
    
    public func isNull() -> Predicate {
        return .expression(left: self.sqlParameter, operator: .equal, right: .null)
    }
    
    public func isNotNulll() -> Predicate {
        return .not(isNull())
    }
}


// MARK: Compound predicate

public func && (lhs: Predicate, rhs: Predicate) -> Predicate {
    return .and([lhs, rhs])
}

public func || (lhs: Predicate, rhs: Predicate) -> Predicate {
    return .or([lhs, rhs])
}

// Predicated query

public protocol PredicatedQuery: class {
    var predicate: Predicate? { get set }
}

public extension PredicatedQuery {
    public func filter(_ value: Predicate) -> Self {
        guard let existing = predicate else {
            predicate = value
            return self
        }
        
        predicate = .and([existing, value])
        return self
    }
}