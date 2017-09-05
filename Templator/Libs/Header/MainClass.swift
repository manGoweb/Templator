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
        if let snp = templator.options[.snapKit] as? Bool, snp == true {
            output = "\(output)import SnapKit\n"
        }
        
        return output + "\n\n"
    }
    
    func basic() -> String {
        var output = importsString()
        let parentClass = (templator.options[.parentClass] as? String) ?? "UIView"
        guard let template = Files.template(named: "class") else {
            return ""
        }
        
        var vars = templator.vars()
        vars["PARENT"] = parentClass
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
                output = "\(output)\tlet \(name): \(className)\n"
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
        if let snp = templator.options[.snapKit] as? Bool, snp == true {
            var output = ""
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
            vars["LAYOUT"] = output
        }
        else {
            vars["LAYOUT"] = ""
        }
        
        // Configure elements
        var output = ""
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
        vars["CONFIGURE"] = output
        
        let parsedElements = Templates.replace(codesIn: elements, with: vars)
        let content = "\(properties())\(parsedElements)"
        
        return content
    }
    
}
