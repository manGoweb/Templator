//
//  CheckboxCell.swift
//  Templator
//
//  Created by Ondrej Rafaj on 05/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation
import Cocoa
import SnapKit


class CheckboxCell: NSTableCellView {
    
    var checkboxChanged: ((_ on: Bool)->())?
    
    let checkbox = NSButton(checkboxWithTitle: "Enable", target: self, action: #selector(didChangeCheckbox(_:)))
    
    // MARK: Actions
    
    func didChangeCheckbox(_ sender: NSButton) {
        checkboxChanged?(sender.state == 1)
    }
    
    // MARK: Initialization
    
    convenience init() {
        self.init(frame: NSRect.zero)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        checkbox.target = self
        addSubview(checkbox)
        checkbox.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
