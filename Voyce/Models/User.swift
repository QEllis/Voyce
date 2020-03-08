
import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI

public class User
{
    let userID: String
    var name: String
    var username: String
    var totalVibes: Int
    var unusedVibes: Int
    var profilePic: URL?
    var followed: Set<String>
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "username": username,
            "totalvibes": totalVibes,
            "unusedVibes": unusedVibes,
            "profilePic": profilePic?.absoluteString as Any
        ]
    }
    
    init() {
        self.userID = "0"
        self.name = "0"
        self.username = "0"
        self.totalVibes = 0
        self.unusedVibes = 0
        self.profilePic = nil
        self.followed = Set<String>.init()
    }
    
    init(userID: String, name: String, username: String) {
        self.userID = userID
        self.name = name
        self.username = username
        self.totalVibes = 0
        self.unusedVibes = 0
        self.profilePic = nil
        self.followed = Set<String>.init()
    }
    
    init(userID: String, name: String, username: String, totalVibes: Int) {
        self.userID = userID
        self.name = name
        self.username = username
        self.totalVibes = totalVibes
        self.unusedVibes = 0
        self.profilePic = nil
        self.followed = Set<String>.init()
    }
    
    init(userID: String, name: String, username: String, totalVibes: Int, profilePic: String) {
        self.userID = userID
        self.name = name
        self.username = username
        self.totalVibes = totalVibes
        self.unusedVibes = 0
        self.profilePic = URL(string: profilePic)
        self.followed = Set<String>.init()
    }
    
    init(user: FirebaseAuth.User) {
        self.userID = user.uid
        self.name = user.displayName!
        self.username = user.displayName!
        self.totalVibes = 0
        self.unusedVibes = 0
        self.profilePic = URL(string: "")
        self.followed = Set<String>.init()
    }
    
    func addFollowed(userID: String) {
        followed.insert(userID)
    }
    
    func removeFollowed(userID: String) {
        followed.remove(userID)
    }
    
    func checkIfFollowed(userID: String) -> Bool {
        if (followed.contains(userID)) {
            return true
        }
        return false
    }
    
    func setVibes(totalVibes: Int) {
        self.totalVibes = totalVibes
    }
    
    func getVibes() -> Int {
        return self.totalVibes
    }
    
    func addVibes(totalVibes: Int) {
        self.totalVibes += totalVibes
    }
    
    func removeVibes()
    {
        if (self.totalVibes >= 1) {
            self.totalVibes -= 1
        }
    }
    
    func loadUserData(document: DocumentSnapshot)
    {
        let vibeCount: Int = document.get("totalVibes") as! Int;
        self.setVibes(totalVibes: vibeCount)
        self.username = document.get("username") as! String
        self.profilePic = URL(string: document.get("profilePic") as! String)
    }
}
