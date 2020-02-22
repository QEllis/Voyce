//
//  Color.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/18/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

public enum Color: String
{
    case Background
    
    public var uiColor: UIColor
    {
        return UIColor(named: self.rawValue)!
    }
    
    public var cgColor: CGColor
    {
        return  UIColor(named: self.rawValue)!.cgColor
    }
    
    public func withAlpha(_ component: CGFloat) -> UIColor
    {
        return self.uiColor.withAlphaComponent(component)
    }
    
}
