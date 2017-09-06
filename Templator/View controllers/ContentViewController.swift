//
//  ContentViewController.swift
//  Templator
//
//  Created by Ondrej Rafaj on 06/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation
import Cocoa
import SnapKit


class ContentViewController: NSViewController {
    
    @IBOutlet var textView: NSTextView!
    
    var file: Templator.Output! {
        didSet {
            textView?.string = file?.content ?? "n/a"
        }
    }
    
    // MARK: View lifecycle
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        textView.string = file?.content ?? "n/a"
    }
    
}

