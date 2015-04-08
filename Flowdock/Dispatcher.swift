//
//  AppCoordinator.swift
//  Flowdock
//
//  Created by Phillip Hutchings on 29/03/15.
//  Copyright (c) 2015 Phillip Hutchings. All rights reserved.
//

import Cocoa
import OAuth2

class Dispatcher {
    let settings = [
        "client_id": Constants.OAuthApplication,
        "client_secret": Constants.OAuthSecret,
        "authorize_uri": "https://api.flowdock.com/oauth/authorize",
        "token_uri": "https://flowdock.com/oauth/token",
        "scope": "flow private manage",
        "redirect_uris": ["urn:ietf:wg:oauth:2.0:oob"],   // don't forget to register this scheme
        ] as OAuth2JSON
    
    let authDelegate = OAuthConnection()
    
    let flowdock : Flowdock
    
    init () {
        flowdock = Flowdock()
        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserverForName(Notifications.RefreshFlows, object: nil, queue: nil,
            usingBlock: refreshFlows)
    }
    
    func refreshFlows(notification : NSNotification!) {
        flowdock.flows()
    }
    
    
    func startLoginForUser(username : String, password : String) {
        let oauth = OAuth2ImplicitGrant(settings: settings)
        oauth.onAuthorize = { parameters in
            println("Did authorize with parameters: \(parameters)")
        }
        oauth.onFailure = { error in        // `error` is nil on cancel
            if nil != error {
                println("Authorization went wrong: \(error!.localizedDescription)")
            }
        }
        
        let request = oauth.tokenRequestForUri((settings["token_uri"] as! String),
            params:["username": username, "password":password, "grant_type":"password", "scope":self.settings["scope"] as! String])
        
        NSURLConnection(request: request, delegate: authDelegate, startImmediately: true)
    }
    
}


class OAuthConnection: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        // FIXME
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
    }
    
    func connection(connection: NSURLConnection, willSendRequest request: NSURLRequest, redirectResponse response: NSURLResponse?) -> NSURLRequest? {
        
        return request
    }
}

extension OAuth2ImplicitGrant {
    func tokenRequestForUri(uri : String, params : [String : String]) -> NSURLRequest {
        let req = NSMutableURLRequest(URL: NSURL(string: uri)!)
        var body : [String: String] = [
            "client_id": (self.settings["client_id"] as! String),
            "client_secret": (self.settings["client_secret"] as! String)
        ]
        for (key, value) in params {
            body[key] = value
        }
        
        var bodyData = OAuth2.queryStringFor(body)
        req.HTTPMethod = "POST"
        req.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        req.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        return req
    }
}