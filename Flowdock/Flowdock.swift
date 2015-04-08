//
//  Flowdock.swift
//  Flowdock
//
//  Created by Phillip Hutchings on 3/04/15.
//  Copyright (c) 2015 Phillip Hutchings. All rights reserved.
//

import Foundation


class Flowdock {
    let apiHost = NSURL(string: "https://api.flowdock.com/")!
    let requestSigner : FlowdockAuthorisation = BasicAuth()
    var delegatesInFlight : [JsonConnectionDelegate] = []
    var connectionsInFlight : [NSURLConnection] = []
    
    init() {
        NSNotificationCenter.defaultCenter()
        .addObserverForName(Notifications.FlowdockConnectionFinished,
            object: nil, queue: nil, usingBlock: removeReferences)
    }
    
    func removeReferences( n: NSNotification!) {
        let connection = n.userInfo!["connection"] as! NSURLConnection
        let delegate = n.userInfo!["delegate"] as! JsonConnectionDelegate
        delegatesInFlight = delegatesInFlight.filter({n in n != delegate})
        connectionsInFlight = connectionsInFlight.filter({n in n != connection})
    }
    
    internal func flows() {
        let url = NSURL(string:"/flows?users=0", relativeToURL:apiHost)!
        let request = requestSigner.createGetRequest(url)
        let delegate = FlowdockFlowsDelegate()
        delegatesInFlight.append(delegate)
        let connection = NSURLConnection(request: request, delegate: delegate, startImmediately: true)!
        connectionsInFlight.append(connection)
    }
    
}

class FlowdockFlowsDelegate : JsonConnectionDelegate {
    override func jsonRecieved(json: AnyObject) {
        if let items = json as? [AnyObject] {
            let flows = items.map({ (n : AnyObject) in
                (n as? [String : AnyObject]) >>= self.parseFlow})
            
            println(flows)
        }
    }
    
    func parseFlow(json : [String : AnyObject]) -> Flow? {
        let flow = mkFlow <*> string(json, "id")
            <*> string(json, "name")
        
        return Optional(flow!("parameterised_name")(0)(true)(true)("test")("web")("join")("Organisation"))
        /*mkFlow <*> string(json, "id")
            <*> string(json, "name")
            <*> string(json, "parameterised_name")
            <*> number(json, "unread_mentions")
            <*> bool(json, "open")
            <*> bool(json, "joined")
            <*> string(json, "url")
            <*> string(json, "web_url")
            <*> string(json, "access_mode")*/
    }
    
}