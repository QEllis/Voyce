//
//  RootNavigationController.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/18/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit

private let userManager = DatabaseManager.shared
@available(iOS 13.0, *)
class RootNavigationController: UINavigationController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        routeUser()
    }
    
    //    Changed this to Login to test Login functionality
    private func routeUser()
    {
        guard let loginNav = UIStoryboard(name: "Login", bundle: nil)
            .instantiateInitialViewController() as? StartUpViewController else { return }
        viewControllers = [loginNav]
    }
}
