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

private let user = DatabaseManager.shared.sharedUser

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyPostTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    // --- Used for firebase functions below ---
    // lazy var functions = Functions.functions()
    
    // Member Variables
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var goodVibesLabel: UILabel!
    var followed:Bool = false

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    
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
        //profile image
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageClick)))
        profileImage.isUserInteractionEnabled = true
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
    }

    override func viewDidAppear(_ animated: Bool)
    {
        loadTextFields()
        tableView.reloadData()
    }
    //handles loading images into profile UIView
    @objc func handleImageClick(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newProfileImage: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            newProfileImage = editedImage
        }else if let original = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            newProfileImage = original
        }
        if let newImage = newProfileImage{
            profileImage.image = newImage
        }
        DatabaseManager.shared.uploadImage(image: profileImage)
        
        dismiss(animated: true, completion: nil)

        
    }
    //if we exit picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
        return DatabaseManager.shared.myPosts.count
    }
    
    // Requires my MyPostTableViewCellDelegate, which in turn requires the promoteButtonDidPressed function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPostCell") as! MyPostTableViewCell
        cell.fillOut(with: DatabaseManager.shared.myPosts[indexPath.row])
        cell.delegate = self
        return cell
    }

    func promoteButtonDidPressed(post: Post)
    {
        
    }

    @objc private func newPosts()
    {
        print("New opsts reload")
        tableView.reloadData()
    }
    
    func loadProfilePic(){
        /*
        URLSession.shared.dataTask(with: DatabaseManager.shared.sharedUser.profilePic?.absoluteString) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
 */
    }
    
    // ---- Does not compile due to firebase functions installation that is required ----
    // Uses Dwolla API and Firebase Functions to make API Request
    // Transfer funds to user for vibes will be implemented in the future
    @IBAction func transferButtonPressed(_ sender: Any)
    {

    }
}
