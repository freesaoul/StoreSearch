//
//  Search.swift
//  StoreSearch
//
//  Created by Anthony Camara on 17/07/2015.
//  Copyright (c) 2015 Anthony Camara. All rights reserved.
//

import Foundation

class Search {
    
// MARK: - Property
    
    var searchResults = [SearchResult]()
    var hasSearched =   false
    var isLoading =     false
    
    private var dataTask: NSURLSessionDataTask? = nil
  
    
// MARK: - Exec WebRequest
    
    func performSearchForText(text: String, category: Int, completion: SearchComplete) {
        if !text.isEmpty {
            dataTask?.cancel()
            
            isLoading = true
            hasSearched = true
            searchResults = [SearchResult]()
            
            let url = urlWithSearchText(text, category: category)
            
            let session = NSURLSession.sharedSession()
            dataTask = session.dataTaskWithURL(url, completionHandler: { data, response, error in
                
                var success = false
                
                if let error = error {
                    if error.code == -999 {return}
                } else if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let dictionary = self.parseJSON(data) {
                            self.searchResults = self.parseDictionary(dictionary)
                            self.searchResults.sort(<)
                            
                            println("Succes! ")
                            self.isLoading = false
                            success = true
                            //return
                        }
                    }
                }
                
                if !success {
                    self.isLoading = false
                    self.hasSearched = false
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    completion(success)
                }
            })
            
            dataTask?.resume()
        }
    }
    
    
// MARK: - Create Url
    
    private func urlWithSearchText(searchText: String, category: Int) -> NSURL {
        var entityName: String
        
        switch category {
        case 1: entityName = "musicTrack"
        case 2: entityName = "software"
        case 3: entityName = "ebook"
        default: entityName = ""
        }
        
        let escapedSearchText = searchText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let urlString = String(format: "http://itunes.apple.com/search?term=%@&limit=200&entity=%@", escapedSearchText, entityName)
        let url = NSURL(string: urlString)
        return url!
    }
    
    
// MARK: JSON Handler
    
    private func parseJSON(data: NSData) -> [String: AnyObject]? {
        var error: NSError?
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error) as? [String: AnyObject] {
            return json
        } else if let error = error {
            println("JSON Error: \(error)")
        } else {
            println("Unknow JSON Error")
        }
        return nil
    }
    
    
// MARK: - Handle Dictionary
    
    private func parseDictionary(dictionary: [String: AnyObject]) -> [SearchResult] {
        var searchResults = [SearchResult]()
        
        if let array: AnyObject = dictionary["results"] {
            for resultDic in array as! [AnyObject] {
                if let resultDic = resultDic as? [String: AnyObject] {
                    var searchResult: SearchResult?
                    
                    if let wrapperType = resultDic["wrapperType"] as? String {
                        switch wrapperType {
                        case "track":
                            searchResult = parseTrack(resultDic)
                        case "audiobook":
                            searchResult = parseAudioBook(resultDic)
                        case "software":
                            searchResult = parseSoftware(resultDic)
                        default:
                            break
                        }
                    } else if let kind = resultDic["kind"] as? String {
                        if kind == "ebook" {
                            searchResult = parseEBook(resultDic)
                        }
                    }
                    
                    if let result = searchResult {
                        searchResults.append(result)
                    }
                } else {
                    println("Expected a dictionary")
                }
            }
        } else {
            println("Expected 'results' array")
        }
        return searchResults
    }
    
    
// MARK: - Parse WebService Result
    
    private func parseTrack(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult()
        
        searchResult.name = dictionary["trackName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["trackViewUrl"] as! String
        searchResult.kind = dictionary["kind"] as! String
        searchResult.currency = dictionary["currency"] as! String
        
        if let price = dictionary["trackPrice"] as? Double {
            searchResult.price = price
        }
        if let genre = dictionary["primaryGenreName"] as? String {
            searchResult.genre = genre
        }
        
        return searchResult
    }
    
    
    private func parseAudioBook(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult()
        
        searchResult.name = dictionary["collectionName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["collectionViewUrl"] as! String
        searchResult.kind = "audiobook"
        searchResult.currency = dictionary["currency"] as! String
        
        if let price = dictionary["collectionPrice"] as? Double {
            searchResult.price = price
        }
        if let genre = dictionary["primaryGenreName"] as? String {
            searchResult.genre = genre
        }
        
        return searchResult
    }
    
    
    private func parseSoftware(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult()
        
        searchResult.name = dictionary["trackName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["trackViewUrl"] as! String
        searchResult.kind = dictionary["kind"] as! String
        searchResult.currency = dictionary["currency"] as! String
        
        if let price = dictionary["price"] as? Double {
            searchResult.price = price
        }
        if let genre = dictionary["primaryGenreName"] as? String {
            searchResult.genre = genre
        }
        
        return searchResult
    }
    
    
    private func parseEBook(dictionnary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult()
        
        searchResult.name = dictionnary["trackName"] as! String
        searchResult.artistName = dictionnary["artistName"] as! String
        searchResult.artworkURL60 = dictionnary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionnary["artworkUrl100"] as! String
        searchResult.storeURL = dictionnary["trackViewUrl"] as! String
        searchResult.kind = dictionnary["kind"] as! String
        searchResult.currency = dictionnary["currency"] as! String
        
        if let price = dictionnary["price"] as? Double {
            searchResult.price = price
        }
        if let genres: AnyObject = dictionnary["genres"] {
            searchResult.genre = ", ".join(genres as! [String])
        }
        
        return searchResult
    }

}


typealias SearchComplete = (Bool) -> Void
