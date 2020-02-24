
import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI

public class User{
  
  let userID:String
  let name:String
  let username:String
  var goodVibes:Int
  let imageURL: URL?
  let image:UIImage?
  var followed:Set<String>
    
  var dictionary: [String: Any] {
    return [
    "username": username,
    "name": name,
      "goodvibes": goodVibes,
      "imageURL": imageURL?.absoluteString
    ]
  }
  
  init(){
      self.userID = "0"
      self.name = "0"
      self.username = "0"
      self.goodVibes = 0
      self.imageURL = nil
      self.image = nil
      self.followed = Set<String>.init()
  }
  
  init(userID:String, name:String, username:String, goodVibes:Int){
    self.userID = userID
    self.name = name
    self.username = username
    self.goodVibes = goodVibes
    self.imageURL = nil
    self.image = nil
    self.followed = Set<String>.init()
  }
  
  init(userID:String, name:String, username:String, imageURL:String, goodVibes:Int){
    self.userID = userID
    self.name = name
    self.username = username
    self.goodVibes = goodVibes
    self.imageURL = URL(string: imageURL)
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
  
  init(user: FirebaseAuth.User){
      self.userID = user.uid
      self.name = user.displayName!
      self.username = user.displayName!
      self.imageURL = user.photoURL
      self.image = nil
      self.followed = Set<String>.init()
      self.goodVibes = 0
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
    
    func removeVibes(){
         print("remove vibes");
         if(self.goodVibes>=1){
             self.goodVibes -= 1
         }
     }
    
    func LoadUserData(dataDict: [String : Any]){
        print(dataDict)
    }
}
