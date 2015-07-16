//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Anthony Camara on 15/07/2015.
//  Copyright (c) 2015 Anthony Camara. All rights reserved.
//

import UIKit


class SearchResultCell: UITableViewCell {

// MARK: - Property
    
    var downloadTask: NSURLSessionDownloadTask?
    
// MARK: - IBOutlet
    
    @IBOutlet weak var nameLabel:           UILabel!
    @IBOutlet weak var artistNameLabel:     UILabel!
    @IBOutlet weak var artworkImageView:    UIImageView!

    
// MARK: - Custom Cell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectView = UIView(frame: CGRect.zeroRect)
        selectView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectView
    }
    

// MARK: - Config Cell
    
    func configureForSearchResult(searchResult: SearchResult) {
        nameLabel.text = searchResult.name
        
        if searchResult.artistName.isEmpty {
            artistNameLabel.text = "Unknow"
        } else {
            artistNameLabel.text = String(format: "%@ (%@)", searchResult.artistName, kindForDisplay(searchResult.kind))
        }
        artworkImageView.image = UIImage(named: "Placeholder")
        if let url = NSURL(string: searchResult.artworkURL60) {
            downloadTask = artworkImageView.loadImageWithURL(url)
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        downloadTask?.cancel()
        downloadTask = nil
        
        nameLabel.text = nil
        artistNameLabel.text = nil
        artworkImageView.image = nil
        println("prepareForReuse")
    }
    
    
// MARK: - Kind manager
    
    func kindForDisplay(kind: String) -> String {
        switch kind {
        case "album": return "Album"
        case "audiobook": return "Audio Book"
        case "book": return "Book"
        case "ebook": return "E-book"
        case "feature-movie": return "Movie"
        case "music-video": return "Music Video"
        case "podcast": return "Podcast"
        case "software": return "App"
        case "song": return "Song"
        case "tv-episode": return "TV Episode"
        default: return kind
        }
    }
    
}
