//
//  VoyceTabBar.swift
//  Voyce
//
//  Created by Quinn Ellis on 10/29/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

protocol VoyceTabBarDelegate: class {
  func tabBar(from: Int, to: Int)
}

class VoyceTabBar: UIView {

  public enum Tab: Int {
    case home = 0
    case profile = 1
    case menu = 2
  }

  var selectedTab: Tab = .home

  @IBOutlet var contentView: UIView!
  @IBOutlet var homeIcon: UIImageView!
  @IBOutlet var profileIcon: UIImageView!
  @IBOutlet var menuIcon: UIImageView!
  @IBOutlet var homeButton: UIButton!
  @IBOutlet var profileButton: UIButton!
  @IBOutlet var menuButton: UIButton!

  weak var delegate: VoyceTabBarDelegate?

  let home = UIImage(named: "wand")
  let homeSelected = UIImage(named: "wand")
  let profile = UIImage(named: "defaultUserImage")
  let profileSelected = UIImage(named: "defaultUserImage")
  let menu = UIImage(named: "menuDots")
  let menuSelected = UIImage(named: "menuDots")

  public func showTab(_ tab: Tab) {
    delegate?.tabBar(from: selectedTab.rawValue, to: tab.rawValue)
    // update selected
    selectedTab = tab
    setIcons()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = self.bounds
  }

  private func commonInit() {
    Bundle.main.loadNibNamed("VoyceTabBar", owner: self, options: nil)
    contentView.frame = bounds
    addSubview(contentView)
  }

  private func setIcons() {
    switch selectedTab.rawValue {
    case 0:
      homeIcon.image = homeSelected
      profileIcon.image = profile
      menuIcon.image = menu
    case 1:
      homeIcon.image = home
      profileIcon.image = profileSelected
      menuIcon.image = menu
    case 2:
      homeIcon.image = home
      profileIcon.image = profile
      menuIcon.image = menuSelected
    default:
      break
    }
  }

  @IBAction func tabPressed(_ sender: UIButton) {
    guard let tab = Tab(rawValue: sender.tag) else { return }
    showTab(tab)
  }

}
