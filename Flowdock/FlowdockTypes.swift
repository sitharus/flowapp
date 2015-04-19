//
//  FlowdockTypes.swift
//  Flowdock
//
//  Created by Phillip Hutchings on 6/04/15.
//  Copyright (c) 2015 Phillip Hutchings. All rights reserved.
//

import Foundation

enum FlowAccessMode {
    case Organisation
    case Invitation
    case Link
    case Other(String)
}

struct Flow {
    let id : String
    let name : String
    let parameterized_name : String
    let unread_mentions : Int
    let open : Bool
    let joined : Bool
    let url : String
    let web_url : String
    let join_url : String?
    let access_mode : String
}

func mkFlow(id : String)(_ name : String)(_ parameterized_name : String)
    (_ unread_metions : Int)(_ open : Bool)(_ joined : Bool)(_ url : String)
    (_ web_url : String)(_ join_url : String?)(_ access_mode : String) -> Flow
{
    return Flow(id: id, name: name, parameterized_name : parameterized_name,
        unread_mentions : unread_metions, open : open, joined : joined,
        url : url, web_url : web_url, join_url : join_url,
        access_mode : access_mode)
}