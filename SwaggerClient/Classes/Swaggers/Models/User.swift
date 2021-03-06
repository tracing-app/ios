//
// User.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** User Schema for API validation and documentation */

public struct User: Codable {

    public var firstName: String?
    public var lastName: String?
    public var email: String
    public var school: String

    public init(firstName: String?, lastName: String?, email: String, school: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.school = school
    }

    public enum CodingKeys: String, CodingKey { 
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case school
    }

}

