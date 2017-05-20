//
//  EnumProtocol.swift
//  AndroidAlertDialogDemo
//
//  Created by Dava on 5/10/17.
//  Copyright © 2017 Davaur. All rights reserved.
//

import Foundation

public protocol EnumProtocol {
    
    associatedtype T
    
    var rawValue: T { get }
    var value: T { get }
}

extension EnumProtocol {
    var value: T {
        return rawValue
    }
}
