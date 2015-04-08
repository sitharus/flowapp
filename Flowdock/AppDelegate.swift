//
//  AppDelegate.swift
//  Flowdock
//
//  Created by Phillip Hutchings on 29/03/15.
//  Copyright (c) 2015 Phillip Hutchings. All rights reserved.
//

import Cocoa

struct Constants {
    static let OAuthCompletedKey = "OAUTH_COMPLETED"
    static let OAuthApplication = ""
    static let OAuthSecret = ""
}
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet
    var MainWindow : NSWindow!
    @IBOutlet
    var mainWindowViewController : MainWindowViewController!
    
    let dispatcher = Dispatcher()
    let flowdock = Flowdock()


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }
    
    @IBAction
    func authorise(sender: AnyObject) {
        let auth = OAuthWindowController(dispatcher: dispatcher)
        auth.showWindow(self)
        
    }
    
    func authDismissed() {
        
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

