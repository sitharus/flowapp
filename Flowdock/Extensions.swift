//
//  Extensions.swift
//  Flowdock
//
//  Created by Phillip Hutchings on 8/04/15.
//  Copyright (c) 2015 Phillip Hutchings. All rights reserved.
//

import Foundation

infix operator <*> { associativity left precedence 150 }

func <*><A, B>(f: (A -> B)?, x: A?) -> B? {
    if let f1 = f {
        if let x1 = x {
            return f1(x1)
        }
    }
    return nil
}

infix operator  >>= {}
func >>= <U,T>(optional : T?, f : T -> U?) -> U? {
    return optional.flatMap(f)
}

func array(input: [String:AnyObject], key: String) ->  [AnyObject]? {
    let maybeAny : AnyObject? = input[key]
    return maybeAny >>= { $0 as? [AnyObject] }
}

func dictionary(input: [String:AnyObject], key: String) ->  [String:AnyObject]? {
    return input[key] >>= { $0 as? [String:AnyObject] }
}

func string(input: [String:AnyObject], key: String) -> String? {
    return input[key] >>= { $0 as? String }
}

func number(input: [NSObject:AnyObject], key: String) -> NSNumber? {
    return input[key] >>= { $0 as? NSNumber }
}

func int(input: [NSObject:AnyObject], key: String) -> Int? {
    return number(input,key).map { $0.integerValue }
}

func bool(input: [NSObject:AnyObject], key: String) -> Bool? {
    return number(input,key).map { $0.boolValue }
}
 