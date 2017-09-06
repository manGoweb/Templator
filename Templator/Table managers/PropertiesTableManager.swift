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
    
    var didChange: ((_ property: Item, _ row: Int)->())?
    var finishedEditing: ((_ property: Item, _ row: Int)->())?
    
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
        let item = data[row]
        
        if tableColumn == tableView.tableColumns[0] {
            let cell = TextFieldCell()
            let text: String
            switch item {
            case .property(let name, _):
                text = name
            case .view(let name, _, _):
                text = name
            case .separator:
                text = "--------"
            case .group(let name):
                text = "// " + name
            }
            cell.editField.stringValue = text
            cell.valueChanged = { text in
                let newItem: Item
                switch item {
                case .property(_, let className):
                    newItem = Item.property(text, className)
                case .view(_, let className, let fulscreen):
                    newItem = Item.view(text, className, fulscreen)
                case .separator:
                    return
                case .group:
                    let trimmed = text.trimmed()
                    newItem = Item.group(trimmed)
                }
                self.didChange?(newItem, row)
            }
            cell.finishedEditing = { text in
                let newItem: Item
                switch item {
                case .property(_, let className):
                    newItem = Item.property(text, className)
                case .view(_, let className, let fulscreen):
                    newItem = Item.view(text, className, fulscreen)
                case .separator:
                    return
                case .group:
                    let trimmed = text.trimmed()
                    newItem = Item.group(trimmed)
                }
                self.finishedEditing?(newItem, row)
            }
            return cell
        }
        else if tableColumn == tableView.tableColumns[1] {
            let cell = TextFieldCell()
            let text: String
            switch item {
            case .property(_, let className):
                text = className
            case .view(_, let className, _):
                text = className
            case .separator:
                text = "--------"
            case .group(_):
                text = ""
            }
            cell.editField.stringValue = text
            cell.valueChanged = { text in
                let newItem: Item
                switch item {
                case .property(let name, _):
                    newItem = Item.property(name, text)
                case .view(let name, _, let fulscreen):
                    newItem = Item.view(name, text, fulscreen)
                case .separator:
                    return
                case .group:
                    return
                }
                self.didChange?(newItem, row)
            }
            cell.finishedEditing = { text in
                let newItem: Item
                switch item {
                case .property(let name, _):
                    newItem = Item.property(name, text)
                case .view(let name, _, let fulscreen):
                    newItem = Item.view(name, text, fulscreen)
                case .separator:
                    return
                case .group:
                    return
                }
                self.finishedEditing?(newItem, row)
            }
            return cell
        }
        else if tableColumn == tableView.tableColumns[2] {
            let cell = TextFieldCell()
            let text: String
            switch item {
            case .property(_, _):
                text = "Property"
            case .view(_, _, _):
                text = "View"
            case .separator:
                text = "--------"
            case .group(_):
                text = "Group"
            }
            cell.editField.stringValue = text
            return cell
        }
        
        return nil
    }
    
}
