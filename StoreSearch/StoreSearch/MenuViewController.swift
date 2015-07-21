//
//  MenuViewController.swift
//  StoreSearch
//
//  Created by Anthony Camara on 21/07/2015.
//  Copyright (c) 2015 Anthony Camara. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol MenuViewControllerDelegate: class {
    func menuViewControllerSendSupportEmail(MenuViewController)
}


class MenuViewController: UITableViewController {

// MARK: - Property

    
    weak var delegate: MenuViewControllerDelegate?
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 {
            delegate?.menuViewControllerSendSupportEmail(self)
        }
    }
}