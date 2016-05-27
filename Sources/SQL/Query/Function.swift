//
//  Function.swift
//  SQL
//
//  Created by David Ask on 24/05/16.
//
//

public enum Function {
    case sum(QualifiedField)
}

extension Function: SQLStringRepresentable {
    public var sqlString: String {
        switch self {
        case .sum(let field):
            return "sum(\(field.qualifiedName))"
        }
    }
}

extension Function: ParameterConvertible {
    public var sqlParameter: Parameter {
        return .function(self)
    }
}

public func sum(_ field: QualifiedField) -> Function {
    return .sum(field)
}

public func sum(_ field: QualifiedField, as alias: String) -> Select.Component {
    return .function(.sum(field), alias: alias)
}