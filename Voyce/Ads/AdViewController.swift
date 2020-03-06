//
//  AdViewController.swift
//  Voyce
//
//  Created by Cole Gifford on 10/1/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

private let shared = UserManager.shared
class AdViewController: UIViewController {

  @IBOutlet var vibezLabel: UILabel!
  @IBOutlet var adLabel: UILabel!
  @IBOutlet var videoLabel: UILabel!
  @IBOutlet var imageAdView: UIImageView!
  @IBOutlet var adView: UIView!

  var vibes = 0
  var adNumber = 0
  var timer: Timer?
  //  var ads:[Ad] = []
  var ads = NSMutableArray()
  var icon = UIImage(named: "wand")

  override func viewDidLoad(){
    print("Ads View Did Load")
    super.viewDidLoad();
    //self.title = "Ads"
    self.navigationItem.title="Ads"
    initTimer()
    stopTimer()
    ads.addObjects(from: [UIImage(named: "Beach"),
                          UIImage(named: "Getty"),
                          UIImage(named: "Concert"),
                          "Text Advertisement"])

    //FRANK assuming this will come in as an array of Strings or UIImages
    vibes = UserManager.shared.sharedUser.getVibes()

    let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(sender:)))
    rightSwipe.direction = .right
    view.addGestureRecognizer(rightSwipe)
    let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(sender:)))
    leftSwipe.direction = .left
    view.addGestureRecognizer(rightSwipe)
    view.addGestureRecognizer(leftSwipe)
    print("View did appear")
    if (loadNewAds()) {
        print("starting timer")
      startTimer()
    }
    let adNumber = 0
    if ads[adNumber] is String {
      adLabel.text = ads[adNumber] as? String
      adLabel.isHidden = false
      imageAdView.isHidden = true
      videoLabel.isHidden = true
    } else if ads[adNumber] is UIImage {
      imageAdView.image = ads[adNumber] as? UIImage
      adLabel.isHidden = true
      imageAdView.isHidden = false
      videoLabel.isHidden = true
    } else {
      adLabel.isHidden = true
      imageAdView.isHidden = true
      videoLabel.isHidden = false
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    print("Triggered view did disappear")
    stopTimer()
  }
  
  func startTimer() {
    print("in start timer function")
    stopTimer()
    guard self.timer == nil else { return }
    initTimer()
    vibes = UserManager.shared.sharedUser.getVibes()
  }
  
  func stopTimer() {
    guard timer != nil else { return }
    timer?.invalidate()
    timer = nil
    UserManager.shared.sharedUser.setVibes(vibes: self.vibes)
  }
  
  func loadNewAds()->Bool{
    //to be called when view appears
    //pull from database
    //filter ads that the user already disliked
    if (ads.count > 0 && adNumber < ads.count) {
      print("New ads: count: \(ads.count), adNumber:\(adNumber)")
      return true
    }
    else{
        print("in load new ads-false")
      return false
    }
  }
  
  func showEmptyAd(){
    adLabel.text = "No more ads to show"
    adLabel.isHidden = false
    //imageAdView.isHidden = true
    videoLabel.isHidden = true
    stopTimer()
  }


  @IBAction func swipeHandler(sender : UISwipeGestureRecognizer) {
    if sender.state == .ended {
      if(ads.count == 0){
        showEmptyAd()
        return
      }
      // Perform action.
      switch sender.direction {
      case .right :
        //tell add that you don't like it
        let originalCenter = adView.center
        UIView.animate(withDuration: 0.5, animations: {
          self.adView.frame.origin = CGPoint(x: self.view.frame.width, y: self.adView.frame.origin.y)
        }, completion: { _ in
          self.adView.center = originalCenter
        })
        adNumber += 1
      case .left:
        //tell add that you like it
        let originalCenter = adView.center
        UIView.animate(withDuration: 0.5, animations: {
          self.adView.frame.origin = CGPoint(x: -self.view.frame.width, y: self.adView.frame.origin.y)
        }, completion: { _ in
          self.adView.center = originalCenter
        })
        adNumber += 1
      default:
        break
      }

      if adNumber >= ads.count {
        //show no more ads message
        showEmptyAd()
        return
      }
      if adNumber < 0 {
        showEmptyAd()
        return
      }

      print(adNumber)
      if ads[adNumber] is String {
        adLabel.text = ads[adNumber] as? String
        adLabel.isHidden = false
        imageAdView.isHidden = true
        videoLabel.isHidden = true
      } else if ads[adNumber] is UIImage {
        imageAdView.image = ads[adNumber] as? UIImage
        adLabel.isHidden = true
        imageAdView.isHidden = false
        videoLabel.isHidden = true
      } else {
        adLabel.isHidden = true
        imageAdView.isHidden = true
        videoLabel.isHidden = false
      }
    }
  }

  func initTimer(){
    // Scheduling timer to Call the function "updateViewTime" with the interval of 1 seconds
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateViewTime), userInfo: nil, repeats: true)
  }

  @objc func updateViewTime(){
    print("in update view time")
          //UserManager.shared.sharedUser.goodVibes += 1
    vibes += 1 //FRANK update server side amount of vibez
    shared.db.collection("users").document(shared.sharedUser.userID).setData([ "goodvibes": vibes ], merge: true);
    print(shared.sharedUser.userID);
    vibezLabel.text = "Good Vibes: \(vibes)"
  }
  
}
