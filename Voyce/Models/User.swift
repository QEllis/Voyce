//
//  User.swift
//  Voyce
//
//  Created by Student on 10/17/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI

public class User{
  
  let userID:String
  let name:String
  let username:String
  let goodVibes:Int
  let imageURL: URL?
  let image:UIImage?
  var followed:Set<String>
  
  init(userID:String, name:String, username:String, goodVibes:Int){
    self.userID = userID
    self.name = name
    self.username = username
    self.goodVibes = goodVibes
    self.imageURL = nil
    self.image = nil
    self.followed = Set<String>.init()
  }
  init(userID:String, name:String, username:String){
    self.userID = userID
    self.name = name
    self.username = username
    self.goodVibes = 0
    self.imageURL = nil
    self.image = nil
    self.followed = Set<String>.init()
  }
    init(){
        let user = Auth.auth().currentUser
        
        self.userID = user!.uid
        self.name = (user?.displayName!)!
        self.username = (user?.displayName!)!
        self.imageURL = user?.photoURL
        self.image = nil
        self.followed = Set<String>.init()
        self.goodVibes = 0
        
        self.setGoodVibes()
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
    
  func setGoodVibes(){
    //goodVibes = 
  }
  
}
