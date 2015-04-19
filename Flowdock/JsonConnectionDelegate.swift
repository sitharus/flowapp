//
//  JsonConnectionDelegate.swift
//  Flowdock
//
//  Created by Phillip Hutchings on 6/04/15.
//  Copyright (c) 2015 Phillip Hutchings. All rights reserved.
//

import Foundation

class JsonConnectionDelegate : NSObject, NSURLConnectionDataDelegate {
    let data : NSMutableData = NSMutableData()
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.data.appendData(data)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
    }
    
    func jsonRecieved(json : AnyObject) {
        
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        let error = NSErrorPointer()
        let json : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: error)
        
        if let result: AnyObject = json {
            jsonRecieved(result)
        }
        let message = FlowdockFinished(connection, delegate: self)
        Dispatcher.globalDispatcher?.postNotification(.FlowdockConnectionFinished, notification: message)
    }
}