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
    @IBOutlet var feedIcon: UIImageView!
    @IBOutlet var adIcon: UIImageView!
    @IBOutlet var addPostIcon: UIImageView!
    @IBOutlet var findPeopleIcon: UIImageView!
    @IBOutlet var profileIcon: UIImageView!
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
        // update selected
        selectedTab = tab
        setIcons()
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
    
    private func setIcons()
    {
        switch selectedTab.rawValue
        {
        case 0:
            feedIcon.image = feedSelected
            adIcon.image = ad
            addPostIcon.image = addPost
            findPeopleIcon.image = findPeople
            profileIcon.image = profile
        case 1:
            feedIcon.image = feed
            adIcon.image = adSelected
            addPostIcon.image = addPost
            findPeopleIcon.image = findPeople
            profileIcon.image = profile
        case 2:
            feedIcon.image = feed
            adIcon.image = ad
            addPostIcon.image = addPostSelected
            findPeopleIcon.image = findPeople
            profileIcon.image = profile
//        case 3:
//            feedIcon.image = feed
//            adIcon.image = ad
//            addPostIcon.image = addPost
//            findPeopleIcon.image = findPeopleSelected
//            profileIcon.image = profile
        case 4:
            feedIcon.image = feed
            adIcon.image = ad
            addPostIcon.image = addPost
            findPeopleIcon.image = findPeople
            profileIcon.image = profileSelected
        default:
            break
        }
    }
    
    @IBAction func tabPressed(_ sender: UIButton)
    {
        guard let tab = Tab(rawValue: sender.tag) else { return }
        showTab(tab)
    }
    
}
