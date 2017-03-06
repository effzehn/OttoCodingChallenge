//
//  ViewController.swift
//  OttoCodingChallenge
//
//  Created by Developer on 10.12.16.
//  Copyright © 2016 Andre Hoffmann. All rights reserved.
//

import UIKit
import WebKit

let DefaultTimeout: TimeInterval = 5
let StartURLString = "https://www.mytoys.de"

let MenuSegue = "MenuSegue"

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView?
    @IBOutlet weak var menuButton: UIBarButtonItem?
    
    @IBOutlet weak var menuSegue: UIStoryboardSegue?
    
    var menuItem: MenuItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuButton?.isEnabled = false
        
        if let url = URL(string: StartURLString) {
            let startRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: DefaultTimeout)
            webView?.loadRequest(startRequest)
        }
        
        Service().requestMenu(success: { [unowned self] dict in
            self.menuItem = MenuItem.menuItemWithDictionary(dictionary: dict)
            DispatchQueue.main.sync() {
                self.menuButton?.isEnabled = true
            }
        }, failure: { error in
            // TODO: Implement some UI error handling
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController, let menuItem = menuItem {
            if let menuViewController = navigationController.topViewController as? MenuViewController {
                let menuViewModel = MenuViewModel(menuItem: menuItem)
                menuViewModel.menuViewDelegate = self
                menuViewController.viewModel = menuViewModel
            }
        }
    }
}

extension ViewController: MenuViewDelegate {

    func menuViewController(controller: MenuViewController, didSelectNewPageWithURL pageURL: URL) {
        let request = URLRequest(url: pageURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: DefaultTimeout)
        webView?.loadRequest(request)
    }
}
