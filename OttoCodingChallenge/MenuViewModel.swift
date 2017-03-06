//
//  MenuViewModel.swift
//  OttoCodingChallenge
//
//  Created by Developer on 10.12.16.
//  Copyright © 2016 Andre Hoffmann. All rights reserved.
//

import Foundation

protocol MenuViewDelegate: class {
    func menuViewController(controller: MenuViewController, didSelectNewPageWithURL pageURL: URL)
}

class MenuViewModel {
    
    weak var menuViewDelegate: MenuViewDelegate?
    var rootMenuItem: MenuItem
    
    init(menuItem: MenuItem) {
        rootMenuItem = menuItem
    }
    
    var title: String { get { return rootMenuItem.label } }
    
    func itemForRow(atIndexPath indexPath: IndexPath) -> MenuItem? {
        guard let count = rootMenuItem.children?.count, count > indexPath.row else {
            return nil
        }
        return rootMenuItem.children?[indexPath.row]
    }
    
    func numberOfRows() -> Int? {
        return rootMenuItem.children?.count
    }
}
