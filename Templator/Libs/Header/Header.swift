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
    
    func basic() -> String {
        guard let template = Files.template(named: "header") else {
            return ""
        }
        
        let parsed = Templates.replace(codesIn: template, with: templator.vars())
        return parsed
    }
    
}
