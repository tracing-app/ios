//
// MgmtAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire


open class MgmtAPI {
    /**
     Health Check

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func healthcheck(completion: @escaping ((_ data: String?,_ error: Error?) -> Void)) {
        healthcheckWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Health Check
     - GET /health

     - examples: [{contentType=application/json, example=""}]

     - returns: RequestBuilder<String> 
     */
    open class func healthcheckWithRequestBuilder() -> RequestBuilder<String> {
        let path = "/health"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<String>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
