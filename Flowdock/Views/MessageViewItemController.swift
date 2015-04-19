//
//  MessageItemController.swift
//  Flowdock
//
//  Created by Phillip Hutchings on 14/04/15.
//  Copyright (c) 2015 Phillip Hutchings. All rights reserved.
//

import Cocoa

class MessageViewItemController : NSViewController {
    
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        if let nibName = nibNameOrNil {
            NSLog("Got a nib name when I didn't expect one! %@", nibName)
            exit(1)
        } else {
            super.init(nibName: "MessageItem", bundle: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
