//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Anthony Camara on 16/07/2015.
//  Copyright (c) 2015 Anthony Camara. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

// MARK: Property
    
    var searchResult:   SearchResult! {
        didSet {
            if isViewLoaded() {
                updateUI()
            }
        }
    }
    var downloadTask:   NSURLSessionDownloadTask?
    enum                AnimationStyle {
        case Slide
        case Fade
    }
    var dismissAnimationStyle = AnimationStyle.Fade
    var isPopUp = false
    
// MARK: - IBOutlet
    
    @IBOutlet weak var popupView:           UIView!
    @IBOutlet weak var artworkImageView:    UIImageView!
    @IBOutlet weak var nameLabel:           UILabel!
    @IBOutlet weak var artistNameLabel:     UILabel!
    @IBOutlet weak var kindLabel:           UILabel!
    @IBOutlet weak var genreLabel:          UILabel!
    @IBOutlet weak var priceButton:         UIButton!
    
    
// MARK: - IBAction
    
    @IBAction func close() {
        dismissAnimationStyle = .Slide
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func openInStore() {
        if let url = NSURL(string: searchResult.storeURL) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    
// MARK: - Init Class
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    deinit {
        downloadTask?.cancel()
    }
    
    
// MARK: - Init View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        popupView.layer.cornerRadius = 10
        
        if isPopUp {
            view.backgroundColor = UIColor.clearColor()
        
            let gestureReconizer = UITapGestureRecognizer(target: self, action: Selector("close"))
            gestureReconizer.cancelsTouchesInView = false
            gestureReconizer.delegate = self
            view.addGestureRecognizer(gestureReconizer)
        } else {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
            popupView.hidden = true
            if let displayName = NSBundle.mainBundle().localizedInfoDictionary?["CFBundleDisplayName"] as? String {
                title = displayName
            }
        }
        
        if searchResult != nil {
            updateUI()
        }
        
    }
    
    func updateUI() {
        nameLabel.text = searchResult.name
        
        if searchResult.artistName.isEmpty {
            artistNameLabel.text = NSLocalizedString("Unknow", comment: "Localized artistName: Unknow")
        } else {
            artistNameLabel.text = searchResult.artistName
        }
        
        kindLabel.text = searchResult.kindForDisplay()
        genreLabel.text = searchResult.genre
    
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.currencyCode = searchResult.currency
        
        var priceText: String
        if searchResult.price == 0 {
            priceText = NSLocalizedString("Free", comment: "Localized priceText: Free")
        } else if let text = formatter.stringFromNumber(searchResult.price) {
            priceText = text
        } else {
            priceText = ""
        }
        
        priceButton.setTitle(priceText, forState: .Normal)
        
        if let url = NSURL(string: searchResult.artworkURL100) {
            downloadTask = artworkImageView.loadImageWithURL(url)
        }
        popupView.hidden = false
    }
    
}


// MARK: - Delegate UIViewControllerTransitioning

extension DetailViewController: UIViewControllerTransitioningDelegate {
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return DimmingPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissAnimationStyle {
        case .Slide:
            return SlideOutAnimationController()
        case .Fade:
            return FadeOutAnimationController()
        }
    }
    
}


// MARK: - Delegate GestureReconizer

extension DetailViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return (touch.view === view)
    }
}
