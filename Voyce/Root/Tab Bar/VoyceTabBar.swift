//
//  VoyceTabBar.swift
//  Voyce
//
//  Created by Quinn Ellis on 10/29/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

protocol VoyceTabBarDelegate: class
{
    func tabBar(from: Int, to: Int)
}

class VoyceTabBar: UIView
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
    let adSelected = UIImage(named: "Ad Feed Selected")
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
    }
    
    @IBAction func feedButtonPressed(_ sender: UIButton) {
        feedButton.setImage(feedSelected, for: UIControlState.normal)
        adButton.setImage(ad, for: UIControlState.normal)
        addPostButton.setImage(addPost, for: UIControlState.normal)
        findPeopleButton.setImage(findPeople, for: UIControlState.normal)
        profileButton.setImage(profile, for: UIControlState.normal)
        
        guard let tab = Tab(rawValue: sender.tag) else { return }
        print(sender.tag)
        showTab(tab)
    }
    
    @IBAction func adButtonPressed(_ sender: UIButton) {
        feedButton.setImage(feed, for: UIControlState.normal)
        adButton.setImage(adSelected, for: UIControlState.normal)
        addPostButton.setImage(addPost, for: UIControlState.normal)
        findPeopleButton.setImage(findPeople, for: UIControlState.normal)
        profileButton.setImage(profile, for: UIControlState.normal)
        
        guard let tab = Tab(rawValue: sender.tag) else { return }
        print(sender.tag)
        showTab(tab)
    }
    
    @IBAction func addPostButtonPressed(_ sender: UIButton) {
        feedButton.setImage(feed, for: UIControlState.normal)
        adButton.setImage(ad, for: UIControlState.normal)
        addPostButton.setImage(addPostSelected, for: UIControlState.normal)
        findPeopleButton.setImage(findPeople, for: UIControlState.normal)
        profileButton.setImage(profile, for: UIControlState.normal)
        
        guard let tab = Tab(rawValue: sender.tag) else { return }
        print(sender.tag)
        showTab(tab)
    }
    @IBAction func findPeopleButtonPressed(_ sender: UIButton) {
        feedButton.setImage(feed, for: UIControlState.normal)
        adButton.setImage(ad, for: UIControlState.normal)
        addPostButton.setImage(addPost, for: UIControlState.normal)
        findPeopleButton.setImage(findPeopleSelected, for: UIControlState.normal)
        profileButton.setImage(profile, for: UIControlState.normal)
        
        guard let tab = Tab(rawValue: sender.tag) else { return }
        print(sender.tag)
        showTab(tab)
    }
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        feedButton.setImage(feed, for: UIControlState.normal)
        adButton.setImage(ad, for: UIControlState.normal)
        addPostButton.setImage(addPost, for: UIControlState.normal)
        findPeopleButton.setImage(findPeople, for: UIControlState.normal)
        profileButton.setImage(profileSelected, for: UIControlState.normal)
        
        guard let tab = Tab(rawValue: sender.tag) else { return }
        print(sender.tag)
        showTab(tab)
    }
}
