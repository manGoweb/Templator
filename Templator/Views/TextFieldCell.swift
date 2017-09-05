//
//  TextFieldCell.swift
//  Templator
//
//  Created by Ondrej Rafaj on 05/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation
import Cocoa
import SnapKit


class TextFieldCell: NSTableCellView, NSTextFieldDelegate {
    
    var valueChanged: ((_ value: String)->())?
    var editField = NSTextField()
    
    // MARK: Initialization
    
    convenience init() {
        self.init(frame: NSRect.zero)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        editField = NSTextField()
        editField.isBordered = false
        editField.backgroundColor = .clear
        editField.delegate = self
        addSubview(editField)
        editField.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Text field delegate methods
    
    override func controlTextDidBeginEditing(_ obj: Notification) {
        editField.backgroundColor = .white
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        valueChanged?(editField.stringValue)
    }
    
}

