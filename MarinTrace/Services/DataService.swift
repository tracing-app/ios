//
//  DataService.swift
//  MarinTrace
//
//  Created by Beck Lorsch on 6/7/20.
//  Copyright © 2020 Marin Trace. All rights reserved.
//

import Foundation
import SwaggerClient
import Alamofire
import FirebaseCrashlytics
import Auth0

typealias Contact = SwaggerClient.User

//MARK: Data Service
struct DataService {
        
    /// Get headers for HTTP requests
    /// - Parameters:
    ///   - completion: Completion handler callback
    ///   - token: The  token
    ///   -  error: An error
    static func getHeaders(completion: @escaping(_ token: String?, _ error: Error?) -> Void) {
        SwaggerClientAPI.basePath = "http://marintracingapp.org/rest" //TODO - https
        credentialsManager.credentials { (error, creds) in
            if error != nil {
                completion(nil, error)
                if error != nil {
                    logError(error: error!)
                }
            } else {
                completion("Bearer \(creds!.idToken!)", nil)
            }
        }
    }
    
    /// List all users within school for contact search
    /// - Parameters:
    ///  - completion: Completion handler callback
    ///  - contacts: Array of the school's contacts
    ///  - error: An error
    static func listUsers(completion: @escaping(_ contacts: [Contact]?, _ error: Error?) -> Void) {
        getHeaders { (token, error) in
            if error != nil {
                completion(nil, error)
            } else {
                SyncAPIAPI.listUsers(authorization: token!) { (response, apiError) in
                    if let error = apiError {
                        completion(nil, error)
                        logError(error: error)
                    } else {
                        completion(response?.users, nil)
                    }
                }
            }
        }
    }
    
    /// Report an interaction
    /// - Parameters:
    ///   - targetIDS: The ids (email before @) of the people interacted with
    ///   - completion: Completion handler callback
    ///   -  error: An error
    static func reportInteractions(targetIDS: [String], completion: @escaping(_ error: Error?) -> Void) {
        getHeaders { (token, error) in
            if error != nil {
                completion(error)
            } else {
                let report = InteractionReport(targets: targetIDS)
                AsyncAPIAPI.queueInteractionReport(body: report, authorization: token!) { (_, apiError) in
                    if let error = apiError {
                        completion(error)
                        logError(error: error)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    /// Marks a user as active in the DB
    /// - Parameters:
    ///   - completion: Completio handler callback
    ///   - error: An error
    static func markUserAsActive(completion: @escaping(_ error:Error?) -> Void){
        getHeaders { (token, error) in
            if error != nil {
                completion(error)
            } else {
                AsyncAPIAPI.queueSetActiveUser(authorization: token ?? "") { (_, apiError) in
                    if let error = apiError {
                        completion(error)
                        logError(error: error)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    /// Notifies server of user's symptoms.
    /// - Parameters:
    ///   -  completion: Completion handler callback
    ///   -  symptoms: The user's symptoms
    ///   -  error: An error
    static func reportSymptoms(symptoms: SwaggerClient.SymptomReport, completion: @escaping(_ error: Error?) -> Void) {
        getHeaders { (token, error) in
            if error != nil {
                completion(error)
            } else {
                AsyncAPIAPI.queueSymptomReport(body: symptoms, authorization: token!) { (_, apiError) in
                    if let error = apiError {
                        completion(error)
                        logError(error: error)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    /// Notifies server of user's test.
    /// - Parameters:
    ///   -  completion: Completion handler callback
    ///   -  testType: the type of test
    ///   -  error: An error
    static func reportTest(testType: TestReport.TestType, completion: @escaping(_ error: Error?) -> Void) {
        getHeaders { (token, error) in
            if error != nil {
                completion(error)
            } else {
                AsyncAPIAPI.queueTestReport(body: TestReport(testType: testType), authorization: token!) { (_, apiError) in
                    if let error = apiError {
                        completion(error)
                        logError(error: error)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    /// Gets a user's id (email before @)
    /// - Returns: The user id
    static func getUserID() -> String {
        let email = User.email
        let range = email.range(of: "@")
        let id = String(email[..<range!.lowerBound])
        return id
    }
    
    /// Logs error in firebase/crashlytics with domain, code, and localized description
    /// - Parameter error: Error to report
    static func logError(error: Error) {
        //add localized description in
        let nsError = error as NSError
        var swaggerError = ""
        if let errorResponse = error as? ErrorResponse {
            if let apiError = getAPIError(response: errorResponse) {
                swaggerError = apiError
            }
        }
        let newError = NSError(domain: nsError.domain, code: nsError.code, userInfo: [NSLocalizedDescriptionKey:nsError.localizedDescription, "swaggerError":swaggerError])
        Crashlytics.crashlytics().record(error: newError)
    }
    
    /// Transforms Swagger error into something more readable
    /// - Parameter response: the error response
    /// - Returns: the error description
    
    static func getAPIError(response: ErrorResponse) -> String? {
        switch (response){
        case .error(_, let datavalue, _):
            guard let nonOptionalData = datavalue else {
                return nil
            }
            return String(bytes: nonOptionalData, encoding: .utf8)
        }
    }
    
}
