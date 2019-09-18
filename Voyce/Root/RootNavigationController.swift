//
//  RootNavigationController.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/18/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()
    routeUser()
  }

  //In future this will route user based on login state
  private func routeUser() {
    guard let feedVC = UIStoryboard(name: "Feed", bundle: nil)
      .instantiateInitialViewController() as? FeedViewController else { return }
    viewControllers = [feedVC]
  }

}