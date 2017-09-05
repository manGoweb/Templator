//
//  Files.swift
//  Templator
//
//  Created by Ondrej Rafaj on 04/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation


class Files {
    
    static func template(named name: String) -> String? {
        guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
            return nil
        }
        
        let string = try? String(contentsOfFile: path)
        return string
    }
    
}
