
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
    var adVibes: Int
    var profilePic: URL?
    var followed: Set<String>
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "username": username,
            "totalvibes": totalVibes,
            "unusedVibes": unusedVibes,
            "adVibes": adVibes,
            "profilePic": profilePic?.absoluteString as Any
        ]
    }
    
    init() {
        self.userID = "0"
        self.name = "0"
        self.username = "0"
        self.totalVibes = 0
        self.unusedVibes = 0
        self.adVibes = 0
        self.profilePic = nil
        self.followed = Set<String>.init()
    }
    
    init(userID: String, name: String, username: String) {
        self.userID = userID
        self.name = name
        self.username = username
        self.totalVibes = 0
        self.unusedVibes = 0
        self.adVibes = 0
        self.profilePic = nil
        self.followed = Set<String>.init()
    }
    
    init(userID: String, name: String, username: String, totalVibes: Int) {
        self.userID = userID
        self.name = name
        self.username = username
        self.totalVibes = totalVibes
        self.unusedVibes = 0
        self.adVibes = 0
        self.profilePic = nil
        self.followed = Set<String>.init()
    }
    
    init(userID: String, name: String, username: String, totalVibes: Int, profilePic: String) {
        self.userID = userID
        self.name = name
        self.username = username
        self.totalVibes = totalVibes
        self.unusedVibes = 0
        self.adVibes = 0
        self.profilePic = URL(string: profilePic)
        self.followed = Set<String>.init()
    }
    
    init(user: FirebaseAuth.User) {
        self.userID = user.uid
        self.name = user.displayName!
        self.username = user.displayName!
        self.totalVibes = 0
        self.unusedVibes = 0
        self.adVibes = 0
        self.profilePic = URL(string: "")
        self.followed = Set<String>.init()
        
        
        //clean up, will need to load more things, move to it's own
        //function. This is needed on startup
        let docRef = DatabaseManager.shared.db.collection("users").document(userID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.unusedVibes = document.get("unusedVibes") as! Int
                print("got vibes")
                print(self.unusedVibes);
            } else {
                print("Document does not exist")
            }
        }
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
        let shardRef = DatabaseManager.shared.db.collection("users").document(userID)
                 shardRef.updateData([
                     "unusedVibes": FieldValue.increment(Int64(1))
                 ])
    }
    //remove number of ad vibes
    func removeVibes()
    {
//        if (self.totalVibes >= 1) {
//            self.totalVibes -= 1
//        }
        
        if (self.adVibes >= 1) {
            self.adVibes -= 1
            let shardRef = DatabaseManager.shared.db.collection("users").document(userID)
                    shardRef.updateData([
                        "adVibes": FieldValue.increment(Int64(-1))
                    ])
        }
    }
    
    //sets ad vibes
    func setAdVibes(adVibes: Int){
        self.adVibes = adVibes
    }
    
    //gets ad vibes
    func getAdVibes() -> Int {
        return self.adVibes
    }
    
    func addAdVibes(adVibes: Int) {
        self.adVibes += adVibes
        let shardRef = DatabaseManager.shared.db.collection("users").document(userID)
                 shardRef.updateData([
                     "adVibes": FieldValue.increment(Int64(1))
                 ])
    }
   
    //sets earned vibes
    func setEarnedVibes(unusedVibes: Int){
        self.unusedVibes=unusedVibes
    }
    
    //gets earned vibes
    func getEarnedVibes() -> Int{
        return self.unusedVibes
    }
    
    func addEarnedVibes(unusedVibes: Int){
        self.unusedVibes += unusedVibes
        let shardRef = DatabaseManager.shared.db.collection("users").document(userID)
                shardRef.updateData([
                    "unusedVibes": FieldValue.increment(Int64(1))
                ])
    }
    
    func loadUserData(document: DocumentSnapshot)
    {
        let vibeCount: Int = document.get("totalVibes") as! Int;
        self.setVibes(totalVibes: vibeCount)
        self.username = document.get("username") as! String
        self.profilePic = URL(string: document.get("profilePic") as! String)
    }
    
    func incrementUnusedVibes(){
        let shardRef = DatabaseManager.shared.db.collection("users").document(userID)

          shardRef.updateData([
              "unusedVibes": FieldValue.increment(Int64(1))
          ])
        
    }
    func incrementTotalVibes(){
        let shardRef = DatabaseManager.shared.db.collection("users").document(userID)
                 shardRef.updateData([
                     "totalVibes": FieldValue.increment(Int64(1))
                 ])
    }
    func hasUnusedVibes() -> Bool {
        let docRef = DatabaseManager.shared.db.collection("users").document(userID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.unusedVibes = document.get("unusedVibes") as! Int
                print("got vibes")
                print(self.unusedVibes);
            } else {
                print("Document does not exist")
            }
        }
        print(self.unusedVibes);
        if(self.unusedVibes > 0){
            return true;
        }
            return false;
    }
}
