//
//  Theme.swift
//  To-Go
//
//  Created by Dan Lages on 11/08/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit
import Foundation

let selectedThemeKey = "ThemeKey"

let accentColor = UIColor(red: 93.0/255.0, green: 64.0/255.0, blue: 55.0/255.0, alpha: 1.0) // Define accent color

let mainColor = UIColor(red: 139.0/255.0, green: 107.0/255.0, blue: 97.0/255.0, alpha: 1.0)// Define main color

let mapviewColor = UIColor(red: 0.12/255.0, green: 158.0/255.0, blue: 225.0/255.0, alpha: 1.0)

enum Theme: Int {
    case Default, secondaryColor
    
    var mainColorQuery: UIColor {
        switch self {
        case .Default:
            return mainColor
        case .secondaryColor:
            return mainColor
        }
    }
    
    //Query bar style to Use
    var barStyleQuery: UIBarStyle {
        switch self {
        case .Default:
            return .black
        case .secondaryColor:
            return .default
        }
    }
    
    var navigationColour: UIImage? {
        return self == .secondaryColor ? UIImage(named: "navigationBackgroud") : nil
    }
    
    var tabBarBackground: UIImage? {
        return self == .secondaryColor ? UIImage(named: "tabBarBackground") : nil
    }
    
    var accentColorQuery: UIColor {
        switch self {
        case .Default:
            return accentColor
        case .secondaryColor:
            return accentColor
        }
    }
}

//MARK: Manage Theme

struct ManageThemes {
    
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: selectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        }
        else {
            return .Default
        }
    }
    
    
    //MARK: Apply Theme
    
    static func applyTheme(theme: Theme)
    {
        UserDefaults.standard.set(theme.rawValue, forKey: selectedThemeKey)
        UserDefaults.standard.synchronize()
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = .black
        
        //MARK: Navigation Bar
        UINavigationBar.appearance().barStyle = theme.barStyleQuery
        UINavigationBar.appearance().setBackgroundImage(theme.navigationColour, for: .default)
        UINavigationBar.appearance().barTintColor = theme.accentColorQuery
        
        //MARK: TableView
        UITableView.appearance().backgroundColor = theme.mainColorQuery
        
        //Mark: TableView Cell
        UITableViewCell.appearance().backgroundColor = theme.mainColorQuery

        //MARK Tab Bar
        UITabBar.appearance().barStyle = theme.barStyleQuery
        UITabBar.appearance().backgroundImage = theme.tabBarBackground
        UITabBar.appearance().barTintColor = theme.accentColorQuery
    }
}
