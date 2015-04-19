//
//  MainWindowViewController.swift
//  Flowdock
//
//  Created by Phillip Hutchings on 4/04/15.
//  Copyright (c) 2015 Phillip Hutchings. All rights reserved.
//

import Cocoa

class MainWindowViewController : NSViewController {
    let splitViewController = NSSplitViewController()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        self.view.autoresizesSubviews = true;
        
        let view1 = FlowsViewController()
        let view2 = MessageViewController()
        self.view.addSubview(splitViewController.view)
        
        
        let item1 = NSSplitViewItem(viewController: view1)
        let item2 = NSSplitViewItem(viewController: view2)
        splitViewController.addSplitViewItem(item1)
        splitViewController.addSplitViewItem(item2)
    }
}
