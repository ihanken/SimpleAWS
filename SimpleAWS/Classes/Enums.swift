//
//  Enums.swift
//  SimpleAWS
//
//  Created by Ian Hanken on Friday, December 28, 2016.
//  Copyright © 2016 Ian Hanken. All rights reserved.
//

import Foundation

/* MARK: - Music Enums */
public enum Gender: Int, CustomStringConvertible {
    case unknown = 0, female, male
    
    // Used to determine what to display
    // to users regarding music types
    public var TypeName: String {
        let typeNames = [
            "unknown",
            "Female",
            "Male"
        ]
        
        return typeNames[rawValue]
    }
    
    public var description: String {
        return TypeName
    }
    
}

// Custom function to determine if two music genres are the same.
public func ==(lhs: Gender, rhs: Gender) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

