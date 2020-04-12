//
//  VoyceTabBar.swift
//  Voyce
//
//  Created by Quinn Ellis on 10/29/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

protocol VoyceTabBarDelegate: class
{
    func tabBar(from: Int, to: Int)
}

private let user = DatabaseManager.shared.sharedUser
class VoyceTabBar: UIView, GADRewardedAdDelegate
{
    public enum Tab: Int
    {
        case feed = 0
        case ad = 1
        case addPost = 2
        case findPeople = 3
        case profile = 4
    }
    
    var selectedTab: Tab = .feed
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var feedButton: UIButton!
    @IBOutlet var adButton: UIButton!
    @IBOutlet var addPostButton: UIButton!
    @IBOutlet var findPeopleButton: UIButton!
    @IBOutlet var profileButton: UIButton!
    
    weak var delegate: VoyceTabBarDelegate?
    
    let feed = UIImage(named: "Feed")
    let feedSelected = UIImage(named: "Feed Selected")
    let ad = UIImage(named: "Ad Feed")
    //    let adSelected = UIImage(named: "Ad Feed Selected")
    let addPost = UIImage(named: "Add Post")
    let addPostSelected = UIImage(named: "Add Post Selected")
    let findPeople = UIImage(named: "Find People")
    let findPeopleSelected = UIImage(named: "Find People Selected")
    let profile = UIImage(named: "Profile")
    let profileSelected = UIImage(named: "Profile Selected")
    
    public func showTab(_ tab: Tab)
    {
        delegate?.tabBar(from: selectedTab.rawValue, to: tab.rawValue)
        selectedTab = tab
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        contentView.frame = self.bounds
    }
    
    private func commonInit()
    {
        Bundle.main.loadNibNamed("VoyceTabBar", owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        rewardedAd = createAndLoadRewardedAd()
    }
    
    @IBAction func feedButtonPressed(_ sender: UIButton) {
        feedButton.setImage(feedSelected, for: UIControl.State.normal)
        adButton.setImage(ad, for: UIControl.State.normal)
        addPostButton.setImage(addPost, for: UIControl.State.normal)
        findPeopleButton.setImage(findPeople, for: UIControl.State.normal)
        profileButton.setImage(profile, for: UIControl.State.normal)
        
        guard let tab = Tab(rawValue: sender.tag) else { return }
        showTab(tab)
    }
    
    @IBAction func adButtonPressed(_ sender: UIButton) {
        if rewardedAd?.isReady == true {
            rewardedAd?.present(fromRootViewController: UIApplication.topViewController()!, delegate: self)
        }
        
        delegate?.tabBar(from: sender.tag, to: selectedTab.rawValue)
    }
    
    @IBAction func addPostButtonPressed(_ sender: UIButton) {
        feedButton.setImage(feed, for: UIControl.State.normal)
        adButton.setImage(ad, for: UIControl.State.normal)
        addPostButton.setImage(addPostSelected, for: UIControl.State.normal)
        findPeopleButton.setImage(findPeople, for: UIControl.State.normal)
        profileButton.setImage(profile, for: UIControl.State.normal)
        
        guard let tab = Tab(rawValue: sender.tag) else { return }
        showTab(tab)
    }
    @IBAction func findPeopleButtonPressed(_ sender: UIButton) {
        feedButton.setImage(feed, for: UIControl.State.normal)
        adButton.setImage(ad, for: UIControl.State.normal)
        addPostButton.setImage(addPost, for: UIControl.State.normal)
        findPeopleButton.setImage(findPeopleSelected, for: UIControl.State.normal)
        profileButton.setImage(profile, for: UIControl.State.normal)
        
        guard let tab = Tab(rawValue: sender.tag) else { return }
        showTab(tab)
    }
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        feedButton.setImage(feed, for: UIControl.State.normal)
        adButton.setImage(ad, for: UIControl.State.normal)
        addPostButton.setImage(addPost, for: UIControl.State.normal)
        findPeopleButton.setImage(findPeople, for: UIControl.State.normal)
        profileButton.setImage(profileSelected, for: UIControl.State.normal)
        
        guard let tab = Tab(rawValue: sender.tag) else { return }
        showTab(tab)
    }
    
    /* The code for the loading a Rewarded Ad from AdMob. */
    
    var rewardedAd: GADRewardedAd?
    
    /// Load a new ad in the queue.
    func createAndLoadRewardedAd() -> GADRewardedAd {
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        rewardedAd?.load(GADRequest()) { error in
            if let error = error {
                print("Loading Failed: \(error)")
            } else {
                print("Loading Succeeded")
            }
        }
        return rewardedAd!
    }
    
    /// Tells the delegate that the user earned a reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        user.addVibes(adVibes: Int(truncating: reward.amount))
    }
    /// Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad presented.")
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad dismissed.")
        self.rewardedAd = createAndLoadRewardedAd()
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("Rewarded ad failed to present.")
    }
}

/// Allows the code to access the current UIViewController.
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
