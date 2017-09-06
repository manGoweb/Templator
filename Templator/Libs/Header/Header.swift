//
//  Header.swift
//  Templator
//
//  Created by Ondrej Rafaj on 05/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation


class Header: TemplatorModule {
    
    var templator: Templator!
    
    func basic(fileName: String? = nil) -> String {
        if let value = templator.options[.headerEnable] as? Bool, value == true {
            guard let template = Files.template(named: "header") else {
                return ""
            }
            var vars = templator.vars()
            if fileName != nil {
                vars["FILENAME"] = fileName
            }
            let parsed = Templates.replace(codesIn: template, with: vars)
            return parsed
        }
        return ""
    }
    
}
