//
//  MenuViewController.swift
//  OttoCodingChallenge
//
//  Created by Developer on 10.12.16.
//  Copyright © 2016 Andre Hoffmann. All rights reserved.
//

import UIKit

let SectionCellLabelTag = 100

let MenuViewControllerIdentifier = "MenuViewController"

enum CellIdentifier: String {
    case MenuCellSection
    case MenuCellNode
    case MenuCellLink
}

class MenuViewController: UITableViewController {
    
    @IBOutlet weak var closeButton: UIBarButtonItem?
    
    var viewModel: MenuViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel?.title
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let item = viewModel?.itemForRow(atIndexPath: indexPath) {
            switch item.type {
            case .Section:
                cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.MenuCellSection.rawValue, for: indexPath)
                if let sectionLabel = cell.contentView.viewWithTag(SectionCellLabelTag) as? UILabel {
                    sectionLabel.text = item.label
                }
            case .Node:
                cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.MenuCellNode.rawValue, for: indexPath)
                cell.textLabel?.text = item.label
            case .ExternalLink:
                fallthrough
            case .Link:
                cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.MenuCellLink.rawValue, for: indexPath)
                cell.textLabel?.text = item.label
            default:
                debugPrint("I've made a huge mistake.")
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel?.itemForRow(atIndexPath: indexPath) else {
            return
        }
        
        switch item.type {
        case .Node:
            if let menuViewController = storyboard?.instantiateViewController(withIdentifier: MenuViewControllerIdentifier) as? MenuViewController {
                let menuViewModel = MenuViewModel(menuItem: item)
                menuViewModel.menuViewDelegate = viewModel?.menuViewDelegate
                menuViewController.viewModel = menuViewModel
                navigationController?.pushViewController(menuViewController, animated: true)
            }
        case .ExternalLink:
            fallthrough
        case .Link:
            if let url = item.url {
                navigationController?.dismiss(animated: true, completion: {
                    self.viewModel?.menuViewDelegate?.menuViewController(controller: self, didSelectNewPageWithURL: url)
                })
            } else {
                fallthrough
            }
        default:
            debugPrint("I've made a huge mistake.")
        }
    }
    
    @IBAction func closeButtonTouchInside() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
