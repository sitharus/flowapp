//
//  MessageViewController.swift
//  Flowdock
//
//  Created by Phillip Hutchings on 13/04/15.
//  Copyright (c) 2015 Phillip Hutchings. All rights reserved.
//

import Cocoa

class MessageViewController : NSViewController {
    @IBOutlet
    var messagesView : NSTableView?
    
    dynamic var messages : NSMutableArray = NSMutableArray(capacity: 1000)
    
    
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        if let nibName = nibNameOrNil {
            NSLog("Got a nib name when I didn't expect one! %@", nibName)
            exit(1)
        } else {
            super.init(nibName: "MessageView", bundle: nil)
            NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("newMessage"), userInfo: nil, repeats: true)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    dynamic func newMessage() {
        messagesView?.beginUpdates()
        willChangeValueForKey("messages")
        messages.addObject(FlowMessage(message: "test"))
        didChangeValueForKey("messages")
        messagesView?.endUpdates()
        messagesView?.scrollToEndOfDocument(self)
    }
    
    
}

class FlowMessage : NSObject {
    @IBOutlet
    var message : NSString?
    init(message : NSString) {
        self.message = message
    }
    
    
}