//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Anthony Camara on 15/07/2015.
//  Copyright (c) 2015 Anthony Camara. All rights reserved.
//

import Foundation

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == NSComparisonResult.OrderedAscending
}

func > (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == NSComparisonResult.OrderedDescending
}

func sortByArtistNameASC (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.artistName.localizedStandardCompare(rhs.artistName) == NSComparisonResult.OrderedAscending
}

class SearchResult {
    
// MARK: - Property
    
    var name =          ""
    var artistName =    ""
    var artworkURL60 =  ""
    var artworkURL100 = ""
    var storeURL =      ""
    var kind =          ""
    var currency =      ""
    var price =         0.0
    var genre =         ""
    
    
    
}