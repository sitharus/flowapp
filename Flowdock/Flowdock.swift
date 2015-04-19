//
//  Flowdock.swift
//  Flowdock
//
//  Created by Phillip Hutchings on 3/04/15.
//  Copyright (c) 2015 Phillip Hutchings. All rights reserved.
//

import Foundation

class FlowdockFinished : Notification {
    let connection : NSURLConnection
    let delegate : JsonConnectionDelegate
    
    init(_ connection : NSURLConnection, delegate : JsonConnectionDelegate) {
        self.connection = connection
        self.delegate = delegate
    }
}

class Flowdock {
    let apiHost = NSURL(string: "https://api.flowdock.com/")!
    let requestSigner : FlowdockAuthorisation = BasicAuth()
    var delegatesInFlight : [JsonConnectionDelegate] = []
    var connectionsInFlight : [NSURLConnection] = []
    
    init() {
        Dispatcher.globalDispatcher?
        .addObserverForNotification(NotificationName.FlowdockConnectionFinished,
            call: {[unowned self] n in self.removeReferences(n)})
    }
    
    func removeReferences(n: Notification) -> Bool {
        let info = n as! FlowdockFinished
        delegatesInFlight = delegatesInFlight.filter({n in n != info.delegate})
        connectionsInFlight = connectionsInFlight.filter({n in n != info.connection})
        return false
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

class FlowsNotification : Notification {
    let flows : [Flow]
    init(flows: [Flow]) {
        self.flows = flows
    }
}

class FlowdockFlowsDelegate : JsonConnectionDelegate {
    override func jsonRecieved(json: AnyObject) {
        if let items = json as? [AnyObject] {
            
            let flows = items.map({ (n : AnyObject) in
                (n as? [String : AnyObject]) >>= self.parseFlow})
                .filter({ $0 != nil })
                .map({ $0! })
            Dispatcher.globalDispatcher?.postNotification(.FlowsUpdated,
                notification: FlowsNotification(flows: flows))
            
        }
    }
    
    func parseFlow(json : [String : AnyObject]) -> Flow? {
        if  let id = string(json, "id"),
            let name = string(json, "name"),
            let parameterizedName = string(json, "parameterized_name"),
            let open = bool(json, "open"),
            let joined = bool(json, "joined"),
            let url = string(json, "url"),
            let webUrl = string(json, "web_url"),
            let accessMode = string(json, "access_mode")
        {
            let joinUrl = string(json, "join_url")
            let unreadMentions = int(json, "unread_mentions") ?? 0
            
            return Flow(id: id, name: name, parameterized_name: parameterizedName,
                unread_mentions: unreadMentions, open: open, joined: joined,
                url: url, web_url: webUrl, join_url: joinUrl, access_mode: accessMode)
        
        }
        println("Failed to load flow from \(json)")
        return nil
    }
    
}