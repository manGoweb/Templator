//
//  String+Tools.swift
//  Templator
//
//  Created by Ondrej Rafaj on 06/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation


extension String {
    
    func trimmed() -> String {
        var trimmedString = trimmingCharacters(in: CharacterSet.init(charactersIn: "/"))
        trimmedString = trimmedString.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString
    }
}
