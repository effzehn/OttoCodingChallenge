//
//  MenuItem.swift
//  OttoCodingChallenge
//
//  Created by Developer on 12.12.16.
//  Copyright © 2016 Andre Hoffmann. All rights reserved.
//

import Foundation

let RootMenuTitle = "MyToys"
let RootDictionaryKey = "navigationEntries"

enum MenuDictionaryKeys: String {
    case ItemType = "type"
    case Label = "label"
    case URL = "url"
    case Children = "children"
}

enum NavigationEntryType: String {
    case MenuRoot = "root"
    case Section = "section"
    case Node = "node"
    case Link = "link"
    case ExternalLink = "external-link"
    case Undefined = "undefined"
}

struct MenuItem {
    var type: NavigationEntryType = .Undefined
    var label = String()
    var url: URL?
    var children: [MenuItem]?
    
    static func menuItemWithDictionary(dictionary: [String:Any]) -> MenuItem {
        var menuItem = MenuItem()
        
        // We synthesize the first entry to assign the actual json array as it's children
        if dictionary.keys.first == RootDictionaryKey {
            menuItem.type = .MenuRoot
        } else {
            menuItem.type = NavigationEntryType.init(rawValue: dictionary[MenuDictionaryKeys.ItemType.rawValue] as? String ?? NavigationEntryType.Undefined.rawValue) ?? .Undefined
        }
        
        menuItem.label = dictionary[MenuDictionaryKeys.Label.rawValue] as? String ?? RootMenuTitle
        
        if let urlString = dictionary[MenuDictionaryKeys.URL.rawValue] as? String {
            menuItem.url = URL(string: urlString)
        }
        
        var children = [Any]()
        // if we're in the topmost layer we have to make two exceptions:
        // 1. We need to honor that the top level is an array
        // 2. The top level and the first level needs to be flat so that we see categories and subordinate items in the same table view
        if menuItem.type == .MenuRoot {
            if let rootArray = dictionary.first?.value as? [Dictionary<String, Any>] {
                rootArray.forEach({ item in
                    children.append(item)
                    (item[MenuDictionaryKeys.Children.rawValue] as? [Dictionary<String, Any>])?.forEach({ item in
                        children.append(item)
                    })
                })
            }
        // if we're in any following level there's no flattening and a strict hierarchy
        } else {
            children = dictionary[MenuDictionaryKeys.Children.rawValue] as? [Any] ?? [Any]()
        }
        
        if children.count > 0 {
            menuItem.children = [MenuItem]()
        }
        
        children.forEach { item in
            if let item = item as? [String:Any] {
                menuItem.children!.append(MenuItem.menuItemWithDictionary(dictionary: item))
            }
        }
        
        return menuItem
    }
}
 
