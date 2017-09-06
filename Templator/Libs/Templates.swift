//
//  Templates.swift
//  Templator
//
//  Created by Ondrej Rafaj on 04/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation


class Templates {
    
    static private func dateFormatter(format: String? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format ?? "dd/MM/YYYY"
        return formatter
    }
    
    static func replace(codesIn template: String, with codes: [String: String]) -> String {
        var codes = codes
        
        codes["DATE"] = dateFormatter().string(from: Date())
        codes["YEAR"] = dateFormatter(format: "YYYY").string(from: Date())
        
        var output = template
        for key in codes.keys {
            let value = codes[key]!
            output = output.replacingOccurrences(of: "{\(key.uppercased())}", with: value)
        }
        output = output.replacingOccurrences(of: "\\t", with: "\t")
        return output
    }
    
    static func dynamicProperty(name: String) -> String {
        let prop = "<" + "#T##" + name + "#>"
        return prop
    }
    
}
