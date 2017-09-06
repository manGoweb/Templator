//
//  ViewController.swift
//  Templator
//
//  Created by Ondrej Rafaj on 04/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Cocoa


class ViewController: NSViewController, NSTextFieldDelegate {
    
    let settingsManager = SettingsTableManager()
    @IBOutlet var settingsTable: NSTableView!
    
    let propertiesManager = PropertiesTableManager()
    @IBOutlet var propertiesTable: TableView!
    
    @IBOutlet var documentNameField: NSTextField!
    @IBOutlet var propertyNameField: NSTextField!
    @IBOutlet var viewNameField: NSTextField!
    @IBOutlet var groupNameField: NSTextField!
    
    var tabController: ContentTabViewController!
    
    let templator = Templator()
    
    var tabSubviews: [NSView] = []
    
    
    // MARK: Actions
    
    @IBAction func didPressAddPropertyButton(_ sender: NSButton) {
        guard propertyNameField.stringValue.characters.count > 0 else {
            return
        }
        let parts = propertyNameField.stringValue.trimmed().components(separatedBy: ":")
        let className: String
        if parts.count > 1 {
            className = parts[1].trimmed()
        }
        else {
            className = "AnyObject?"
        }
        templator.properties.append(Templator.PropType.property(parts[0].trimmed(), className))
        
        reloadOutput()
    }
    
    @IBAction func didPressAddViewButton(_ sender: NSButton) {
        guard viewNameField.stringValue.characters.count > 0 else {
            return
        }
        let parts = viewNameField.stringValue.trimmed().components(separatedBy: ":")
        let className: String
        if parts.count > 1 {
            className = parts[1].trimmed()
        }
        else {
            className = "UIView"
        }
        templator.properties.append(Templator.PropType.view(parts[0].trimmed(), className, false))
        
        reloadOutput()
    }
    
    @IBAction func didPressAddGroupButton(_ sender: NSButton) {
        guard groupNameField.stringValue.characters.count > 0 else {
            return
        }
        templator.properties.append(Templator.PropType.group(groupNameField.stringValue))
        
        reloadOutput()
    }
    
    @IBAction func didPressAddSeparatorButton(_ sender: NSButton) {
        guard templator.properties.count > 0 else {
            return
        }
        if let lastItem: Templator.PropType = templator.properties.last {
            switch lastItem {
            case .separator,
                 .group:
                return
            default:
                break
            }
        }
        templator.properties.append(Templator.PropType.separator)
        
        reloadOutput()
    }
    
    @IBAction func didSelectFileTypeButton(_ sender: NSPopUpButton) {
        switch sender.indexOfSelectedItem {
        case 1:
            templator.outputType = .view
        case 2:
            templator.outputType = .cell
        default:
            templator.outputType = .viewController
        }
        reloadOutput()
    }
    
    // MARK: Configurations
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "hello":
            tabController = segue.destinationController as! ContentTabViewController
        default:
            break
        }
    }
    
    var firstLoad: Bool = true
    
    func reloadOutput() {
        let output = templator.output(name: documentNameField.stringValue)
        
        // If we need additional (or fewer) controllers
        if output.count > 0 {
            if tabController.childViewControllers.count != output.count || firstLoad {
                firstLoad = false
                tabController.childViewControllers.removeAll()
                for view in tabSubviews {
                    view.removeFromSuperview()
                }
                tabSubviews.removeAll()
                
                for i: Int in 0...(output.count - 1) {
                    let storyboard = NSStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateController(withIdentifier: "contentViewController") as! ContentViewController
                    controller.file = output[i]
                    tabController.addChildViewController(controller)
                    tabController.tabViewItems[i].label = controller.file?.fileName ?? "Unknown.swift"
                }
            }
            else {
                // Fill in the output data
                for i: Int in 0...(output.count - 1) {
                    guard let controller = tabController.childViewControllers[i] as? ContentViewController else {
                        continue
                    }
                    controller.file = output[i]
                    tabController.tabViewItems[i].label = controller.file?.fileName ?? "Unknown.swift"
                }
            }
        }
        
        propertiesManager.templator = templator
        propertiesTable.reloadData()
    }
    
    func configureSettingsTable() {
        settingsManager.templator = templator
        settingsManager.didChangeSetting = { key, value in
            self.templator.options[key] = value
            self.reloadOutput()
        }
        
        settingsTable.delegate = settingsManager
        settingsTable.dataSource = settingsManager
    }
    
    func configurePropertiesTable() {
        propertiesManager.templator = templator
        propertiesManager.didChange = { property in
            self.templator.properties[property.1] = property.0
        }
        propertiesManager.finishedEditing = { property in
            self.templator.properties[property.1] = property.0
            self.reloadOutput()
        }
        
        propertiesTable.delegate = propertiesManager
        propertiesTable.dataSource = propertiesManager
        
        propertiesTable.deleteRow = { row in
            self.templator.properties.remove(at: row)
            self.reloadOutput()
        }
    }
    
    func configureTextFields() {
        documentNameField.delegate = self
        propertyNameField.delegate = self
        viewNameField.delegate = self
        groupNameField.delegate = self
    }
    
    // MARK: View lifecycle
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSettingsTable()
        configurePropertiesTable()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        configureTextFields()
        reloadOutput()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    // MARK: Text field delegate
    
    override func controlTextDidChange(_ obj: Notification) {
        if let field = obj.object as? NSTextField, field.tag == 10 {
            reloadOutput()
        }
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            switch true {
            case control.tag == 10:
                reloadOutput()
            case control.tag == 100:
                didPressAddPropertyButton(NSButton())
            case control.tag == 101:
                didPressAddViewButton(NSButton())
            case control.tag == 102:
                didPressAddGroupButton(NSButton())
            default:
                return true
            }
        }
        return false
    }

}

