//
//  MainClass.swift
//  Templator
//
//  Created by Ondrej Rafaj on 05/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation


class MainClass: TemplatorModule {
    
    var imports: [String] = [
        "Foundation"
    ]
    
    var templator: Templator!
    
    func importsString() -> String {
        var output = ""
        for imp: String in imports {
            output = "\(output)import \(imp)\n"
        }
        
        // SnapKit
        if let value = templator.options[.snapKit] as? Bool, value == true {
            output = "\(output)import SnapKit\n"
        }
        
        return output + "\n\n"
    }
    
    func defaultBaseClass() -> String {
        let defaultBaseClass: String
        
        if let value = templator.options[.baseClassSystem] as? Bool, value == true {
            switch templator.outputType {
            case .view:
                defaultBaseClass = "View"
            case .cell:
                defaultBaseClass = "TableViewCell"
            case .viewController:
                defaultBaseClass = "ViewController"
            }
        }
        else {
            switch templator.outputType {
            case .view:
                defaultBaseClass = "UIView"
            case .cell:
                defaultBaseClass = "UITableViewCell"
            case .viewController:
                defaultBaseClass = "UIViewController"
            }
        }
        
        return defaultBaseClass
    }
    
    func parentClass() -> String {
        let baseClass = defaultBaseClass()
        var parentClass = (templator.options[.parentClass] as? String) ?? baseClass
        if parentClass.characters.count == 0 {
            parentClass = baseClass
        }
        return parentClass
    }
    
    func basic() -> String {
        var output = importsString()
        
        // Deciding base class
        let parent = parentClass()
        
        // Creating the class
        guard let template = Files.template(named: "class") else {
            return ""
        }
        
        var vars = templator.vars()
        vars["PARENT"] = parent
        vars["CONTENT"] = content()
        
        let parsed = Templates.replace(codesIn: template, with: vars)
        output += parsed
        return output
    }
    
    func properties() -> String {
        var output = ""
        for property: Templator.PropType in templator.properties {
            switch property {
            case .view(let name, let className, _):
                output = "\(output)\tlet \(name) = \(className)()\n"
            case .property(let name, let className):
                output = "\(output)\tvar \(name): \(className)\n"
            case .group(let name):
                output = "\(output)\t// \(name)\n"
            default:
                output = "\(output)\t\n"
            }
        }
        output = "\(output)\n"
        return output
    }
    
    func content() -> String {
        guard let elements = Files.template(named: "elements") else {
            return "Missing elements template!\n"
        }
        guard let snapKit = Files.template(named: "snapkit") else {
            return "missing SnapKit template!\n"
        }
        
        // Layout / SnapKit
        var vars = templator.vars()
        var output = ""
        if let value = templator.options[.baseClassSystem] as? Bool, value == true {
            output = "\(output)\t\tsuper.layoutElements()\n\n"
        }
        if let snp = templator.options[.snapKit] as? Bool, snp == true {
            for property: Templator.PropType in templator.properties {
                switch property {
                case .view(let name, _, let fullscreen):
                    vars["PROPERTY"] = name
                    if fullscreen {
                        vars["MAKE"] = "make.edges.equalToSuperView()"
                    }
                    else {
                        vars["MAKE"] = Templates.dynamicProperty(name: "make.something.right")
                    }
                    let parsedSnapKit = Templates.replace(codesIn: snapKit, with: vars)
                    output = "\(output)\(parsedSnapKit)"
                default:
                    break
                }
            }
        }
        else {
            output = output + "\t\t\n"
        }
        vars["LAYOUT"] = output
        
        // Configure elements
        output = ""
        if let value = templator.options[.baseClassSystem] as? Bool, value == true {
            output = "\(output)\t\tsuper.configureElements()\n\n"
        }
        if let value = templator.options[.configureElements] as? Bool, value == true {
            for property: Templator.PropType in templator.properties {
                switch property {
                case .view(let name, _, _):
                    switch templator.outputType {
                    case .viewController:
                        output = "\(output)\t\tview.addSubview(\(name))\n"
                    case .cell:
                        output = "\(output)\t\tcontentView.addSubview(\(name))\n"
                    default:
                        output = "\(output)\t\taddSubview(\(name))\n"
                        break
                    }
                default:
                    break
                }
            }
        }
        else {
            output = "\t\t\n"
        }
        output = output + initializers()
        
        vars["CONFIGURE"] = output
        
        // Initialization
        if let value = templator.options[.baseClassSystem] as? Bool, value == false {
            let baseType: String
            switch templator.outputType {
            case .view:
                baseType = "init-view"
            case .cell:
                baseType = "init-cell"
            case .viewController:
                baseType = "init-controller"
            }
            
            guard let template = Files.template(named: baseType) else {
                return "Missing init template!\n"
            }
            var baseVars = templator.vars()
            baseVars["FILENAME"] = templator.fileName
            baseVars["PARENT"] = templator.mainClass.parentClass()
            let output = "\n\t\n" + Templates.replace(codesIn: template, with: baseVars)
            
            vars["INIT"] = output
        }
        else {
            vars["INIT"] = ""
        }
        
        let parsedElements = Templates.replace(codesIn: elements, with: vars)
        let content = "\(properties())\(parsedElements)"
        
        return content
    }
    
    // MARK: Initializers
    
    func initializers() -> String {
        return ""
    }
    
}
