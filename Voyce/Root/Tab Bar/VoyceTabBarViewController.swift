//
//  VoyceTabBarViewController.swift
//  Voyce
//
//  Created by Quinn Ellis on 10/29/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

class VoyceTabBarViewController: UITabBarController {

  var voyceTabBar: VoyceTabBar = VoyceTabBar()
  @IBInspectable var defaultIndex : Int = 2

  fileprivate var debouncedUpdateTab: (() -> Void)!

  fileprivate var fromIndex: Int?
  fileprivate var toIndex: Int?

  override func viewDidLoad() {
    super.viewDidLoad()
    fillOutTabBar()
    selectedIndex = defaultIndex
  }

  private func fillOutTabBar() {
    UserManager.shared.LoadFeed()
    view.layoutIfNeeded()
    let adViewer = UIStoryboard(name: "AdViewer", bundle: nil).instantiateViewController(withIdentifier: "AdViewerVC")

    let profileVC = UIStoryboard(name: "MyProfile", bundle: nil).instantiateViewController(withIdentifier: "MyProfileVC")
    
    let homeVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "FeedVC")
    
    viewControllers = [adViewer, profileVC, homeVC]
    tabBar.shadowImage = UIImage()
    tabBar.backgroundImage = UIImage()
    tabBar.clipsToBounds = true
    voyceTabBar = VoyceTabBar(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: tabBar.frame.height))
    view.addSubview(voyceTabBar)
    voyceTabBar.autoresizingMask = .flexibleTopMargin
    voyceTabBar.delegate = self
    self.updateTab()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    voyceTabBar.frame = tabBar.frame
    voyceTabBar.frame = CGRect(origin: CGPoint(x: 0, y: tabBar.frame.origin.y),
                                size: CGSize(width: voyceTabBar.frame.width,
                                             height: voyceTabBar.frame.height))
  }

  private func updateTab() {
    guard let to = toIndex else { return }
    selectedIndex = to
    guard let toVC = viewControllers?[to] else { return }
    delegate?.tabBarController?(self, didSelect: toVC)
  }

  public func getTabHeight() -> CGFloat {
    return voyceTabBar.bounds.height
  }

}

// MARK: PinataTabBarDelegate

extension VoyceTabBarViewController: VoyceTabBarDelegate {

  func tabBar(from: Int, to: Int) {
    fromIndex = from
    toIndex = to
    updateTab()
  }

}

