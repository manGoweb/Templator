//
//  BaseClasses.swift
//  Templator
//
//  Created by Ondrej Rafaj on 06/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation


class BaseClasses: TemplatorModule {
    
    var templator: Templator!
    
    func baseClass() -> Templator.Output? {
        if let value = templator.options[.baseClassSystem] as? Bool, value == true {
            let fileName = "\(templator.mainClass.parentClass()).swift"
            var output = templator.header.basic(fileName: fileName)
            
            let baseType: String
            switch templator.outputType {
            case .view:
                baseType = "base-view"
            case .cell:
                baseType = "base-cell"
            case .viewController:
                baseType = "base-controller"
            }
            
            guard let template = Files.template(named: baseType) else {
                return Templator.Output(fileName: fileName, content: "Missing base template!\n")
            }
            var vars = templator.vars()
            vars["FILENAME"] = fileName
            vars["PARENT"] = templator.mainClass.parentClass()
            let parsed = Templates.replace(codesIn: template, with: vars)
            
            output = output + parsed
            return Templator.Output(fileName: fileName, content: output)
        }
        
        return nil
    }
    
}
