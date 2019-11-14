//
//  Ad.swift
//  Voyce
//
//  Created by Student on 11/12/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation

enum Gender{
  case Male
  case Female
  case Other
  case All
}

class Ad:Post{
  var ageRangeLow:Int
  var ageRangeHigh:Int
  var impressions:Int
  var gender:Gender
  
//  init(){
//    self.ageRangeLow = 0
//    self.ageRangeHigh = 100
//    self.impressions = 1
//    self.gender = Gender.All
//    super.init()
//  }
  
  override init(post:Post){
    self.ageRangeLow = 0
    self.ageRangeHigh = 100
    self.impressions = 1
    self.gender = Gender.All
    super.init(post: post)
  }
  
  init(post:Post, ageRangeLow:Int, ageRangeHigh:Int, impressions:Int, gender:Gender){
    self.ageRangeLow = ageRangeLow
    self.ageRangeHigh = ageRangeHigh
    self.impressions = impressions
    self.gender = gender
    super.init(post: post)
  }
}


