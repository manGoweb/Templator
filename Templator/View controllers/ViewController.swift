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
    
    let propertiesManager = PropertiesTableManager()
    @IBOutlet var propertiesTable: NSTableView!
    
    var tabController: ContentTabViewController!
    
    let templator = Templator()
    
    var tabSubviews: [NSView] = []
    
    
    // MARK: Actions
    
    
    
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
    
    func refreshOutput() {
        if templator.properties.count < 10 {
            templator.properties.append(Templator.PropType.group("Properties"))
            templator.properties.append(Templator.PropType.property("justVariable", "AnyClass?"))
            templator.properties.append(Templator.PropType.separator)
            templator.properties.append(Templator.PropType.group("Views"))
            templator.properties.append(Templator.PropType.view("justView", "UIView", true))
            templator.properties.append(Templator.PropType.view("anotherView", "UILabel", false))
            templator.properties.append(Templator.PropType.separator)
        }
        
        let output = templator.output(type: .viewController, name: "MyFirstViewController")
        
        // If we need additional (or fewer) controllers
        if output.count > 0 {
            if tabController.childViewControllers.count != output.count {
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

        // TODO: Can we get rid of this?
        propertiesManager.templator = templator
        propertiesTable.reloadData()
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
        propertiesManager.didChange = { property in
            print(property)
        }
        
        propertiesTable.delegate = propertiesManager
        propertiesTable.dataSource = propertiesManager
    }
    
    func configureTabController() {
//        tabController = ContentTabViewController()
//        addChildViewController(tabController)
//        view.addSubview(tabController.view)
//
//        tabController.view.layer?.backgroundColor = NSColor.red.cgColor
//        tabController.view.snp.makeConstraints { (make) in
//            make.top.equalTo(20)
//            make.bottom.right.equalTo(-2)
//            make.left.equalTo(settingsTable.snp.right).offset(8)
//        }
    }
    
    // MARK: View lifecycle
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSettingsTable()
        configurePropertiesTable()
        configureTabController()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        refreshOutput()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

}

