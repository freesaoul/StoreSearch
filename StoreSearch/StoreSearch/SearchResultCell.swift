//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Anthony Camara on 15/07/2015.
//  Copyright (c) 2015 Anthony Camara. All rights reserved.
//

import UIKit


class SearchResultCell: UITableViewCell {

// MARK: - IBOutlet
    
    @IBOutlet weak var nameLabel:           UILabel!
    @IBOutlet weak var artistNameLabel:     UILabel!
    @IBOutlet weak var artworkImageView:    UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectView = UIView(frame: CGRect.zeroRect)
        selectView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectView
    }
    
}
