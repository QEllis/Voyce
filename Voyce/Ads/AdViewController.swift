//
//  AdViewController.swift
//  Voyce
//
//  Created by Cole Gifford on 10/1/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

class AdViewController: UIViewController {
    
    var vibez = 0
    var adNumber = 0
    var timer = Timer()
    var ads = NSMutableArray()
    var showingTextAd : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad();
        initTimer()
        ads.addObjects(from: ["this is our fist test ad", "this is our second test ad", "this is our third test ad"]) //FRANK assuming this will come in as an array of Strings or UIImages
        if ads[0] is String {
            showingTextAd = true
        } else {
            showingTextAd = false
        }
        vibez = 0
    }
    
    @IBOutlet var vibezLabel: UILabel!
    @IBOutlet var adLabel: UILabel!
    @IBOutlet var imageAdView: UIImageView!
    
    @IBAction func handleAdSwipe(recognizer:UISwipeGestureRecognizer) {
        let translation = recognizer.location(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        adNumber += 1
        if adNumber >= ads.count {
            adNumber = 0
        }
        if ads[adNumber] is String {
            showingTextAd = true
            adLabel.text = ads[adNumber] as? String
        } else {
            showingTextAd = false
            imageAdView.image = ads[adNumber] as? UIImage
        }
        adLabel.isHidden = !showingTextAd
        imageAdView.isHidden = showingTextAd
    }
    
    func initTimer(){
        // Scheduling timer to Call the function "updateViewTime" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateViewTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateViewTime(){
        vibez += 1 //FRANK update server side amount of vibez
        vibezLabel.text = "Good Vibez: \(vibez)"
    }

}
