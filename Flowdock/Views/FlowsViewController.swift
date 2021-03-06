//
//  FlowsViewController.swift
//  Flowdock
//
//  Created by Phillip Hutchings on 4/04/15.
//  Copyright (c) 2015 Phillip Hutchings. All rights reserved.
//

import Cocoa

class FlowsViewController : NSViewController {
    
    @IBOutlet
    var outlineView : NSOutlineView!
    
    @IBOutlet
    var outlineSource : FlowTreeDataSource!
    
    init?(dispatcher : Dispatcher) {
        super.init(nibName: "FlowsView", bundle: nil)
    }
    

    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        if let nibName = nibNameOrNil {
            NSLog("Got a nib name when I didn't expect one! %@", nibName)
            exit(1)
        } else {
            super.init(nibName: "FlowsView", bundle: nil)
        }
    }
    
    override func awakeFromNib() {
        outlineView.expandItem(nil, expandChildren: true)
        let d = Dispatcher.globalDispatcher!
        d.addObserverForNotification(NotificationName.FlowsUpdated,
            call: {[weak self] n in self?.updateFlows(n) ?? false})
        
        //d.postNotification(.RefreshFlows, notification: Notification())
    }
    
    func updateFlows(n : Notification) -> Bool {
        if let flows = n as? FlowsNotification {
            outlineSource.setFlows(flows.flows)
            outlineView.reloadData()
        }
        return true;
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
}

class FlowObject : NSObject {
    var _children : [FlowItem] = []
    let title : String
    
    init(title : String) {
        self.title  = title
    }
    
    var children : [FlowItem] {
        get {
            return _children
        }
    }
    
    var isRoot : Bool {
        return true
    }
    
    func setChildren(children : [FlowItem]) {
        _children = children
    }
    
}

class FlowItem : FlowObject {
    let flow : Flow
    init(title : String, flow : Flow) {
        self.flow = flow
        super.init(title: title)
    }
    
    override var isRoot : Bool {
        return false
    }
}


class FlowTreeDataSource : NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
    let roots = [FlowObject(title: "Flows"), FlowObject(title: "Private")]
    
    @IBOutlet
    weak var view : NSOutlineView?
    
    func setFlows(flows: [Flow]) {
        let flowList = roots[0]
        let flowItems = flows.map { FlowItem(title: $0.name, flow: $0) }
        flowList.setChildren(flowItems)
    }
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if item == nil {
            return count(roots)
        }
        if let fo = item as? FlowObject {
            return count(fo.children)
        }
        fatalError("Unknown index in outline numberOfChildren")
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if let fo = item as? FlowObject {
            return fo.children[index]
        }
        if item == nil {
            return roots[index]
        }
        fatalError("Unknown item in outlineView")
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        if let fo = item as? FlowObject {
            return fo.isRoot ? true : false
        }
        fatalError("Unknown item in outlineView isItemExpandable")
    }
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        if let fo = item as? FlowObject {
            var cell : NSTableCellView
            if fo.isRoot {
                cell = outlineView.makeViewWithIdentifier("HeaderCell", owner: self)! as! NSTableCellView
            } else {
                cell = outlineView.makeViewWithIdentifier("DataCell", owner: self)! as! NSTableCellView
            }
            cell.textField?.stringValue = fo.title
            return cell
        }
        fatalError("Unknown item in outlineView viewForTableColumn")
    }
    
    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        if let fo = item as? FlowObject {
            return fo
        }
        fatalError("Unknown item in outlineView objectValueForTableColumn")
    }
    
    func outlineView(outlineView: NSOutlineView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) {    }
    
    func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
        if let fo = item as? FlowObject {
            return fo.isRoot
        }
        fatalError("Unknown item in outlineView isGroupItem")
    }
    
    func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
        if let fo = item as? FlowObject {
            return !fo.isRoot
        }
        return false
    }
    
    func outlineViewSelectionDidChange(notification: NSNotification) {
        let item : AnyObject? = view!.itemAtRow(view!.selectedRow)
        if let i = item as? FlowItem {
            Dispatcher.globalDispatcher?.postNotification(NotificationName.FlowSelected,
                notification: FlowSelectedNotification(flow: i.flow))
        }
    }
}

class FlowSelectedNotification : Notification {
    init (flow : Flow) {
        
    }
}