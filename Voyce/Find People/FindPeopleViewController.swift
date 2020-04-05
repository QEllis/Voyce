//
//  FindPeople.swift
//  Voyce
//
//  Created by Jordan Ghidossi on 3/6/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import UIKit

class FindPeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    // Member Variables
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var users: [User] = []
    
    // Member Functions
    // Sets the number of table row cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users.count
    }
    
    // Sets the content within each table row cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let userRow = userTableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! UserCell
        userRow.name?.text = users[indexPath.row].name
        userRow.username?.text = users[indexPath.row].username
        userRow.profileImage?.image = URLToImg(users[indexPath.row].profilePic)
        circularImg(imageView: userRow.profileImage.self)
        userRow.selectionStyle = UITableViewCell.SelectionStyle.none
        return userRow
    }
    
    // Preforms an action when the user selects a given cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        searchTextField.resignFirstResponder()
        userTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Changes the shape of each profile image into a circle
    func circularImg(imageView: UIImageView?)
    {
        imageView?.layer.cornerRadius = (imageView?.frame.height ?? 40.0)/2.0
    }
    
    // Converts a URL to an image
    func URLToImg(_ url: URL?) -> UIImage?
    {
        guard let imageURL = url else
        {
            return nil
        }
        let data = try? Data(contentsOf: imageURL)
        return UIImage(data: data!)
    }
    
    // Sets the height of each table cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
    
    // Remove keyboard for when the background is tapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if searchTextField.isFirstResponder && touch?.view != searchTextField
        {
           searchTextField.resignFirstResponder()
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        userTableView.delegate = self
        userTableView.dataSource = self
        users = DatabaseManager.shared.otherUsers
        searchTextField.becomeFirstResponder()
    }
}
