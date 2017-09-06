//
//  TableView.swift
//  Templator
//
//  Created by Ondrej Rafaj on 06/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation
import Cocoa


class TableView: NSTableView {
    
    var deleteRow: ((_ row: Int)->())?
    
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        
        guard event.charactersIgnoringModifiers == String(Character(UnicodeScalar(NSDeleteCharacter)!)) else {
            return
        }
        
        requestDeletionOfSelectedRows()
    }
    
    func requestDeletionOfSelectedRows() {
        guard numberOfSelectedRows > 0 else {
            return
        }
        
        for row in selectedRowIndexes.reversed() {
            deleteRow?(row)
        }
    }
    
}
