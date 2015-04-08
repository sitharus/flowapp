//
//  File.swift
//  Flowdock
//
//  Created by Phillip Hutchings on 6/04/15.
//  Copyright (c) 2015 Phillip Hutchings. All rights reserved.
//

import Foundation

protocol FlowdockAuthorisation {
    func createGetRequest(uri : NSURL) -> NSURLRequest
    func isAuthorised() -> Bool
}

class BasicAuth : FlowdockAuthorisation {
    let username = ""
    let password = ""
    
    func createGetRequest(uri : NSURL) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: uri)
        let authHeader = (count(password) == 0 ? username : "\(username):\(password)")
            .dataUsingEncoding(NSUTF8StringEncoding)?
            .base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        let basicAuth = "Basic \(authHeader!)"
        request.addValue(basicAuth, forHTTPHeaderField: "Authorization")
        
        return request.copy() as! NSURLRequest;
    }
    
    func isAuthorised() -> Bool {
        return true
    }
}