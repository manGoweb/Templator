//
//  SettingsTableManager.swift
//  Templator
//
//  Created by Ondrej Rafaj on 05/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation
import Cocoa


class SettingsTableManager: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    
    var didChangeSetting: ((_ key: Templator.Options, _ value: Any)->())?
    
    typealias Item = (key: Templator.Options, value: Any)
    var data: [Item]!
    var templator: Templator! {
        didSet {
            var data: [Item] = []
            for key: Templator.Options in templator.options.keys {
                if let value: Any = templator.options[key] {
                    data.append((key: key, value: value))
                }
            }
            
            // Sort alphabetically
            self.data = data.sorted(by: { (option1, option2) -> Bool in
                return (option1.key.name() ?? "") < (option2.key.name() ?? "")
            })
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
            cell.editField.stringValue = item.key.name() ?? "Unknown"
            cell.valueChanged = { text in
                self.didChangeSetting?(item.key, text)
            }
            return cell
        }
        else if tableColumn == tableView.tableColumns[1] {
            if let value = item.value as? Bool {
                let cell = CheckboxCell()
                cell.checkbox.state = value ? 1 : 0
                cell.checkboxChanged = { on in
                    self.didChangeSetting?(item.key, on)
                }
                return cell
            }
            else {
                let cell = TextFieldCell()
                cell.editField.stringValue = (item.value as? String) ?? ""
                cell.valueChanged = { text in
                    self.didChangeSetting?(item.key, text)
                }
                return cell
            }
        }
        
        return nil
    }
    
}
