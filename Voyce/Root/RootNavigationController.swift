//
//  RootNavigationController.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/18/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class RootNavigationController: UINavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()
    routeUser()
  }
    
//    Changed this to Login to test Login functionality
  private func routeUser() {

    guard let loginVC = UIStoryboard(name: "Login", bundle: nil)
        .instantiateInitialViewController() as? LoginViewController else { return }
    viewControllers = [loginVC]
    
//    let tabBarVC = UIStoryboard(name: "Root", bundle: nil).instantiateViewController(withIdentifier: "VoyceTabBarVC")
//    viewControllers = [tabBarVC]
  }

}
