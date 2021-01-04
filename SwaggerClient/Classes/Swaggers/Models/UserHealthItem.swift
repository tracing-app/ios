//
// UserHealthItem.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** Entity representing user risk */

public struct UserHealthItem: Codable {

    public enum Color: String, Codable { 
        case danger = "danger"
        case yellow = "yellow"
        case gray = "gray"
        case success = "success"
    }
    public var color: Color?
    public var criteria: [String]?

    public init(color: Color?, criteria: [String]?) {
        self.color = color
        self.criteria = criteria
    }


}
