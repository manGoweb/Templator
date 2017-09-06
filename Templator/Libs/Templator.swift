//
//  Templator.swift
//  Templator
//
//  Created by Ondrej Rafaj on 04/09/2017.
//  Copyright © 2017 manGoweb UK. All rights reserved.
//

import Foundation


protocol TemplatorModule {
    var templator: Templator! { get set }
}

public class Templator {
    
    let header = Header()
    let mainClass = MainClass()
    let baseClasses = BaseClasses()

    public struct Output {
        var fileName: String
        var content: String
    }
    
    enum PropType {
        case view(String, String, Bool)
        case property(String, String)
        case group(String)
        case separator
    }
    
    enum Options {
        case projectName
        case projectAuthor
        case projectCompany
        case parentClass
        case baseClassSystem
        case headerEnable
        case snapKit
        case configureElements
        
        func name() -> String? {
            switch self {
            case .projectName:
                return "Project name"
            case .projectAuthor:
                return "Project author"
            case .projectCompany:
                return "Project company"
            case .parentClass:
                return "Parent class"
            case .baseClassSystem:
                return "Use base class system"
            case .headerEnable:
                return "Generate file headers"
            case .snapKit:
                return "Use SnapKit"
            case .configureElements:
                return "Configure elements"
            }
        }
        
        static func all() -> [Options: Any] {
            var data: [Options: Any] = [:]
            data[.projectName] = "FordPass"
            data[.projectAuthor] = "Ondrej Rafaj"
            data[.projectCompany] = "Ford"
            data[.parentClass] = ""
            data[.baseClassSystem] = false
            data[.headerEnable] = true
            data[.snapKit] = true
            data[.configureElements] = true
            return data
        }
        
        func templateValue() -> String? {
            switch self {
            case .projectName:
                return "PROJECT"
            case .projectAuthor:
                return "AUTHOR"
            case .projectCompany:
                return "COMPANY"
            default:
                return nil
            }
        }
    }
    
    public enum OutputType {
        case view
        case cell
        case viewController
    }
    
    var properties: [PropType] = []
    var options: [Options: Any] = [:] {
        didSet {
            print("Options updated")
        }
    }
    var fileName: String!
    var outputType: OutputType = .viewController
    
    // MARK: Generating code
    
    func vars() -> [String: String] {
        var vars: [String: String] = ["FILENAME": fileName]
        for key in options.keys {
            if let keyValue = key.templateValue() {
                guard let value = options[key] as? String else {
                    continue
                }
                vars[keyValue] = value
            }
        }
        return vars
    }
    
    private func updateModules() {
        header.templator = self
        mainClass.templator = self
        baseClasses.templator = self
    }
    
    public func output(type: OutputType? = nil, name: String) -> [Output] {
        updateModules()
        
        if type != nil {
            outputType = type!
        }
        
        fileName = name
        
        var mainFile = ""
        mainFile.append(header.basic())
        mainFile.append(mainClass.basic())
        var output = [
            Output(fileName: "\(fileName ?? "Unknown").swift", content: mainFile)
        ]
        
        if let baseClassOutput = baseClasses.baseClass() {
            output.append(baseClassOutput)
        }
        return output
    }
    
    // MARK: Initialization
    
    public init() {
        options = Options.all()
    }
    
}
