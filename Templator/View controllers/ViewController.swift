//
//  ViewController.swift
//  Templator
//
//  Created by Ondrej Rafaj on 04/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {
    
    let settingsManager = SettingsTableManager()
    @IBOutlet var settingsTable: NSTableView!
    
    let propertiesManager = SettingsTableManager()
    @IBOutlet var propertiesTable: NSTableView!
    
    @IBOutlet var outputTextView: NSTextView!
    
    @IBOutlet var refreshButton: NSButton!
    
    let templator = Templator()
    
    
    // MARK: Actions
    
    @IBAction func didClickGenerate(_ sender: NSButton) {
        templator.properties.append(Templator.PropType.group("Properties"))
        templator.properties.append(Templator.PropType.property("justVariable", "AnyClass?"))
        templator.properties.append(Templator.PropType.separator)
        templator.properties.append(Templator.PropType.group("Views"))
        templator.properties.append(Templator.PropType.view("justView", "UIView", true))
        templator.properties.append(Templator.PropType.view("anotherView", "UILabel", false))
        templator.properties.append(Templator.PropType.separator)
        
        outputTextView.string = templator.output(type: .viewController, name: "MyFirstViewController").first?.content
    }
    
    // MARK: Configurations
    
    func refreshOutput() {
        didClickGenerate(self.refreshButton)
    }
    
    func configureSettingsTable() {
        settingsManager.templator = templator
        settingsManager.didChangeSetting = { key, value in
            self.templator.options[key] = value
            self.refreshOutput()
        }
        
        settingsTable.delegate = settingsManager
        settingsTable.dataSource = settingsManager
    }
    
    func configurePropertiesTable() {
        propertiesManager.templator = templator
        
        propertiesTable.delegate = propertiesManager
        propertiesTable.dataSource = propertiesManager
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Le Templator"
        
        configureSettingsTable()
        configurePropertiesTable()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

}

