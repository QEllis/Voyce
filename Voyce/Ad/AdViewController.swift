//
//  AdViewController.swift
//  Voyce
//
//  Created by Cole Gifford on 10/1/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

class AdViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
        initTimer()
    }
    
    var vibez = 0 //init to user data
    var adNumber = 0
    var timer = Timer()
    
    @IBOutlet var vibezLabel: UILabel!
    @IBOutlet var adLabel: UILabel!
    
    @IBAction func handleAdSwipe(recognizer:UISwipeGestureRecognizer) {
        let translation = recognizer.location(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        adNumber += 1
        adLabel.text = "ad number \(adNumber)"
    }
    
    func initTimer(){
        // Scheduling timer to Call the function "updateViewTime" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateViewTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateViewTime(){
        vibez += 1
        vibezLabel.text = "Good Vibez: \(vibez)"
    }

}
