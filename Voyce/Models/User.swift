
import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI

public class User
{
    var userID: String
    var name: String
    var username: String
    var adVibes: Int
    var earnedVibes: Int
    var totalVibes: Int
    var profilePic: String
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "username": username,
            "adVibes": adVibes,
            "unusedVibes": earnedVibes,
            "totalVibes": totalVibes,
            "profilePic": profilePic,
            "earnedVibes": earnedVibes
        ]
    }
    
    init() {
        self.userID = "0"
        self.name = "0"
        self.username = "0"
        self.adVibes = 0
        self.earnedVibes = 0
        self.totalVibes = 0
        self.profilePic = ""
    }
    
    init(userID: String, name: String, username: String) {
        self.userID = userID
        self.name = name
        self.username = username
        self.totalVibes = 0
        self.earnedVibes = 0
        self.adVibes = 0
        self.profilePic = ""
    }
    
    init(userID: String, name: String, username: String, totalVibes: Int) {
        self.userID = userID
        self.name = name
        self.username = username
        self.adVibes = 0
        self.earnedVibes = 0
        self.totalVibes = totalVibes
        self.profilePic = ""
    }
    
    init(userID: String, name: String, username: String, adVibes: Int, earnedVibes: Int, totalVibes: Int, profilePic: String) {
        self.userID = userID
        self.name = name
        self.username = username
        self.adVibes = adVibes
        self.earnedVibes = earnedVibes
        self.totalVibes = totalVibes
        self.profilePic = profilePic
    }
    
    init(userID: String, name: String, username: String, totalVibes: Int, profilePic: String) {
        self.userID = userID
        self.name = name
        self.username = username
        self.adVibes = 0
        self.earnedVibes = 0
        self.totalVibes = totalVibes
        self.profilePic = profilePic
    }
    
    init(user: FirebaseAuth.User) {
        self.userID = user.uid
        self.name = user.displayName!
        self.username = ""
        self.totalVibes = 0
        self.earnedVibes = 0
        self.adVibes = 0
        self.profilePic = ""
   
        let docRef = DatabaseManager.shared.db.collection("users").document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.username = document.get("username") as! String
                self.adVibes = document.get("adVibes") as! Int
                self.earnedVibes = document.get("earnedVibes") as! Int
                self.totalVibes = document.get("totalVibes") as! Int
                self.profilePic = document.get("profilePic") as! String
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func loadUserData(document: DocumentSnapshot)
    {
        print(self.profilePic)
        let data = document.data()
        self.userID = document.documentID
        self.name = data?["name"] as! String
        self.username = data?["username"] as! String
        self.adVibes = data?["adVibes"] as! Int
        self.earnedVibes = data?["earnedVibes"] as! Int
        self.totalVibes = data?["totalVibes"] as! Int
        self.profilePic = data?["profilePic"] as! String
    }
    
    func addVibes(adVibes: Int) {
        self.adVibes += adVibes
        let sharedRef = DatabaseManager.shared.db.collection("users").document(userID)
        sharedRef.updateData(["adVibes": FieldValue.increment(Int64(adVibes))])
    }
    
    func addVibes(earnedVibes: Int) {
        self.earnedVibes += earnedVibes
        let sharedRef = DatabaseManager.shared.db.collection("users").document(userID)
        sharedRef.updateData(["earnedVibes": FieldValue.increment(Int64(earnedVibes))])
    }
    
    func addVibes(totalVibes: Int) {
        self.totalVibes += totalVibes
        let sharedRef = DatabaseManager.shared.db.collection("users").document(userID)
        sharedRef.updateData(["totalVibes": FieldValue.increment(Int64(totalVibes))])
    }
    
    func removeAdVibe()
    {
        self.adVibes -= 1
        let sharedRef = DatabaseManager.shared.db.collection("users").document(userID)
        sharedRef.updateData(["adVibes": FieldValue.increment(Int64(-1))])
    }
    
    func removeEarnedVibe() {
        self.earnedVibes -= 1
        let sharedRef = DatabaseManager.shared.db.collection("users").document(userID)
        sharedRef.updateData(["earnedVibes": FieldValue.increment(Int64(-1))])
    }
    
    func hasAdVibes() -> Bool {
        let docRef = DatabaseManager.shared.db.collection("users").document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.adVibes = document.get("adVibes") as! Int
            } else {
                print("Document does not exist")
            }
        }
        if self.adVibes > 0 {
            return true;
        }
        return false;
    }
    
    func hasEarnedVibes() -> Bool {
        let docRef = DatabaseManager.shared.db.collection("users").document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.earnedVibes = document.get("earnedVibes") as! Int
            } else {
                print("Document does not exist")
            }
        }
        if self.earnedVibes > 0 {
            return true;
        }
        return false;
    }
    
    func changeProfilePic(profilePic: String) {
        self.profilePic = profilePic
        
        let sharedRef = DatabaseManager.shared.db.collection("users").document(userID)
        sharedRef.updateData(["profilePic": profilePic])
    }
}
