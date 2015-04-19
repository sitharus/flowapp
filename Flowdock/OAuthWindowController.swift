//
//  OAuthWindowController.swift
//  Flowdock
//
//  Created by Phillip Hutchings on 29/03/15.
//  Copyright (c) 2015 Phillip Hutchings. All rights reserved.
//

import Cocoa

class OAuthWindowController : NSWindowController {
    let dispatcher : Dispatcher
    
    @IBOutlet
    var username : NSTextField!
    
    @IBOutlet
    var password : NSTextField!
    
    init (dispatcher : Dispatcher) {
        self.dispatcher = dispatcher
        super.init(window: nil)
        NSBundle.mainBundle().loadNibNamed("OAuth", owner: self, topLevelObjects:nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loginMessage(n: NSNotification! ) {
        
    }
    
    @IBAction
    func login(sender: AnyObject) {
        dispatcher.startLoginForUser(username.stringValue, password: password.stringValue)
    }
    
    @IBAction
    func cancel(sender: AnyObject) {
        self.close()
    }
    
}