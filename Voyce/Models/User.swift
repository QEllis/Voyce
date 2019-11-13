//
//  User.swift
//  Voyce
//
//  Created by Student on 10/17/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit

public class User{
  
  let userID:Int
  let name:String
  let username:String
  var goodVibes:Int
  let image:UIImage?
  var followed:Set<String>
  
  init(userID:Int, name:String, username:String, goodVibes:Int){
    self.userID = userID
    self.name = name
    self.username = username
    self.goodVibes = goodVibes
    self.image = nil
    self.followed = Set<String>.init()
  }
  init(userID:Int, name:String, username:String){
    self.userID = userID
    self.name = name
    self.username = username
    self.goodVibes = 0
    self.image = nil
    self.followed = Set<String>.init()
  }
  
  func addFollowed(username:String){
    followed.insert(username)
    print(followed)
  }
  
  func removeFollowed(username:String){
    followed.remove(username)
    print(followed)
  }
  
  func checkIfFollowed(username:String)->Bool{
    if(followed.contains(username)){
      return true
    }
    return false
  }
  
  func setVibes(vibes: Int){
    self.goodVibes = vibes
  }
  
  func getVibes()->Int{
    return self.goodVibes
  }
  
  func addVibes(vibes: Int){
    self.goodVibes += vibes
  }
  
}
