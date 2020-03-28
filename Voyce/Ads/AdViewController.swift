//
//  AdViewController.swift
//  Voyce
//
//  Created by Cole Gifford on 10/1/19.
//  Copyright © 2019 QEDev. All rights reserved.
//
import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import GoogleMobileAds
private let user = DatabaseManager.shared.sharedUser
class AdViewController: UIViewController,GADRewardedAdDelegate{
    
     // The rewarded video ad.
    var rewardedAd: GADRewardedAd?
    override func viewDidLoad() {
        print("in ads page")
      super.viewDidLoad()
      rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
      rewardedAd?.load(GADRequest()) { error in
        if let error = error {
          // Handle ad failed to load case.
        } else {
          // Ad successfully loaded.
        }
      }
    }
    
    @IBAction func ButtonClick(_ sender: Any) {
        print(rewardedAd?.isReady)
            if rewardedAd?.isReady == true {
                print("ad true")
             rewardedAd?.present(fromRootViewController: self, delegate:self)
          }
    }

    /// Tells the delegate that the user earned a reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
      print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        //add ad vibes to user account
        user.addAdVibes(adVibes: Int(truncating: reward.amount))
        print(user.getAdVibes())
    }
    /// Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad presented.")
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad dismissed.")
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
      print("Rewarded ad failed to present.")
    }
}
