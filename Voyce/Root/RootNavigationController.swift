//
//  RootNavigationController.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/18/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit


@available(iOS 13.0, *)
class RootNavigationController: UINavigationController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        resetData()
        routeUser()
    }
    
    //    Changed this to Login to test Login functionality
    private func routeUser()
    {
        guard let loginNav = UIStoryboard(name: "Login", bundle: nil)
            .instantiateInitialViewController() as? StartUpViewController else { return }
        viewControllers = [loginNav]
        self.navigationController?.pushViewController(loginNav, animated: true)
    }
    
    // Resets the singleton object when the user signs out of the app and signs in again
    private func resetData()
    {
        DatabaseManager.shared = DatabaseManager()
    }
}
