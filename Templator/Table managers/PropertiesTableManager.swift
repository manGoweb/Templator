//
//  PropertiesTableManager.swift
//  Templator
//
//  Created by Ondrej Rafaj on 05/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation
import Cocoa


class PropertiesTableManager: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    
    var didChange: ((_ property: Item)->())?
    
    typealias Item = Templator.PropType
    
    var data: [Item]!
    var templator: Templator! {
        didSet {
            data = templator.properties
        }
    }
    
    // MARK: Table view delegate & data source methods
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        //let item = data[row]
        
        if tableColumn == tableView.tableColumns[0] {
            let cell = TextFieldCell()
            cell.editField.stringValue = ":)"
            return cell
        }
        else if tableColumn == tableView.tableColumns[1] {
            let cell = TextFieldCell()
            cell.editField.stringValue = ";)"
            return cell
        }
        
        return nil
    }
    
}
