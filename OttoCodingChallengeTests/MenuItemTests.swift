//
//  MenuItemTests.swift
//  OttoCodingChallenge
//
//  Created by Developer on 12.12.16.
//  Copyright © 2016 Andre Hoffmann. All rights reserved.
//

import XCTest

class MenuItemTests: XCTestCase {
    
    var menuItem: MenuItem?
    
    override func setUp() {
        super.setUp()
        
        var menu = [String:Any]()
        try! menu = (JSONSerialization.jsonObject(with: testJSON.data(using: .utf8)!, options: [])) as! [String:Any]
        
        menuItem = MenuItem.menuItemWithDictionary(dictionary: menu)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMenuItemWithDictionary() {
        // The root entry should be of type root
        XCTAssertEqual(menuItem?.type, NavigationEntryType.MenuRoot)
        
        // With some probing we approach if the mapping does work correctly
        // The item should have 10 children
        XCTAssertEqual(menuItem?.children?.count, 10)
        
        // The 8th item should be of type section...
        XCTAssertEqual(menuItem!.children![7].type, NavigationEntryType.Section)
        
        // ...and should have 2 children
        let children = menuItem!.children![7].children!
        XCTAssertEqual(children.count, 2)
        
        // Those children should be of type node
        children.forEach { child in
            XCTAssertEqual(child.type, NavigationEntryType.Node)
        }
        
        // The second child should have 7 children
        XCTAssertEqual(children.last?.children?.count, 7)
    }
}
