//
//  MyProfileViewController.swift
//  Voyce
//
//  Created by Student on 9/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

// --- Used for firebase functions below ---
//import Firebase

import Foundation
import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyPostTableViewCellDelegate
{
    // Member Variables
    private let user = DatabaseManager.shared.sharedUser
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var goodVibesLabel: UILabel!
    var followed: Bool = false
    
    // Member Functions
    override func viewDidLoad()
    {
        // UserManager.shared.initWithPlaceholderPosts()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyPostTableViewCell", bundle: nil), forCellReuseIdentifier: "MyPostCell")
        NotificationCenter.default.addObserver(self, selector: #selector(newPosts), name: .NewPosts, object: nil)
        nameLabel.text = user.name
        usernameLabel.text = "@" + user.username
        goodVibesLabel.text = "Good Vibes: \(user.totalVibes)"
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        loadTextFields()
        tableView.reloadData()
    }
    
    private func loadTextFields()
    {
        print("Loaded Text Fields")
        print("\(DatabaseManager.shared.sharedUser.totalVibes)")
        nameLabel.text = user.name
        usernameLabel.text = "@" + user.username
        goodVibesLabel.text = "Good Vibes: \(user.totalVibes)"
        print(usernameLabel.text ?? "none")
        print(goodVibesLabel.text ?? "none")
        print("users'ad vibes are \(DatabaseManager.shared.sharedUser.adVibes)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return count of my posts
        //        return DatabaseManager.shared.myPosts.count
        return 0
    }
    
    // Requires my MyPostTableViewCellDelegate, which in turn requires the promoteButtonDidPressed function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPostCell") as! MyPostTableViewCell
        //        cell.fillOut(with: DatabaseManager.shared.myPosts[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    @objc private func newPosts()
    {
        print("New opsts reload")
        tableView.reloadData()
    }
    
    func promoteButtonDidPressed(post: Post) {
        
    }
    
    /// Logout current shared user.
    @IBAction func logout(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let error as NSError {
            print ("Error signing out: \(error)")
        }
        
        /// Redirect user back to login.
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
