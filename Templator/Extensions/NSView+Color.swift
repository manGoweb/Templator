//
//  NSView+Color.swift
//  Templator
//
//  Created by Ondrej Rafaj on 06/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation
import Cocoa


extension NSView {
    
    var backgroundColor: NSColor? {
        get {
            guard let color = layer?.backgroundColor else {
                return nil
            }
            return NSColor(cgColor: color)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
    
}
