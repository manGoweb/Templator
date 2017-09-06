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
    
    var deleteRows: ((_ rows: [Int])->())?
    
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        
        guard event.charactersIgnoringModifiers == String(Character(UnicodeScalar(NSDeleteCharacter)!)) else {
            return
        }
    }
    
    func requestDeletionOfSelectedRows() {
        guard numberOfSelectedRows > 0 else {
            return
        }
        let indexes: [Int] = []
        deleteRows?(indexes)
    }
    
}
