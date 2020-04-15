//
//  Money.swift
//  Voyce
//
//  Created by Aron Vischjager on 4/14/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation

class Money
{
    private let shared = DatabaseManager.shared
    var earnedVibes: Int = 0
    var conversionRate: Double = 0.0
    var money: Double = 0.0
    // Initializes the base variables
    init()
    {
        self.earnedVibes = shared.sharedUser.earnedVibes
        self.conversionRate = shared.vibeConversionRate
        roundMoney()
    }
    // Rounds the money equivalent of the goodVibes using the conversionRate to two decimal places
    func roundMoney()
    {
        money = Double(earnedVibes) * conversionRate
        let divisor = pow(10.0, Double(2))
        money = (money * divisor).rounded() / divisor
    }
    // Returns the monitary value of the goodVibes
    func getMoney() -> Double
    {
        return money
    }
}
