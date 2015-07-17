//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Anthony Camara on 16/07/2015.
//  Copyright (c) 2015 Anthony Camara. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
}
