//
//  MenuViewModelTests.swift
//  OttoCodingChallenge
//
//  Created by Developer on 12.12.16.
//  Copyright © 2016 Andre Hoffmann. All rights reserved.
//

import XCTest

class MenuViewModelTests: XCTestCase {
    
    var viewModel: MenuViewModel!
    var menuItem: MenuItem!
    var childItem: MenuItem!
    
    override func setUp() {
        super.setUp()
        
        childItem = MenuItem(type: .Link, label: "Child", url: URL(string:"https://www.mytoys.de"), children: nil)
        menuItem = MenuItem(type: .Node, label: "Parent", url: nil, children: [childItem])
        
        viewModel = MenuViewModel(menuItem: menuItem)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTitle() {
        // The title should be "Parent"
        XCTAssertEqual(viewModel.title, "Parent")
    }
    
    func testItemForRow() {
        // The first item should return the child item
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel.itemForRow(atIndexPath: indexPath)?.label, childItem.label)
        
        // There should be no second item
        let indexPathInvalid = IndexPath(row: 1, section: 0)
        XCTAssertNil(viewModel.itemForRow(atIndexPath: indexPathInvalid))
    }
    
    func testNumberOfRows() {
        // There should be exactly 1 row
        XCTAssertEqual(viewModel.numberOfRows(), 1)
    }
}
