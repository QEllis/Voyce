//
//  DwollaUser.swift
//  Voyce
//
//  Created by Aron Vischjager on 3/29/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation

class DwollaUser
{
    init(_ firstName: String, _ lastName: String, _ email: String, _ accountNumber: String ,_ routingNumber: String)
    {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.accountNumber = accountNumber
        self.routingNumber = routingNumber
    }
    var firstName: String
    var lastName: String
    var email: String
    var accountNumber: String
    var routingNumber: String
}
