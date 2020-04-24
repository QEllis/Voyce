//
//  FindPeople.swift
//  Voyce
//
//  Created by Jordan Ghidossi on 3/6/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import UIKit

class FindPeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
    UISearchBarDelegate
{
    // Member Variables
    @IBOutlet weak var userTableView: UITableView!
    
    var users: [User] = []
    var isComplete:Bool = false
    var RowSelected:Int?
    
    var searching: Bool = false;
    var searchingResult:[User] = []
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        userTableView.delegate = self
        userTableView.dataSource = self
        users = DatabaseManager.shared.otherUsers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Member Functions
    // Sets the number of table row cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(searching){
            return searchingResult.count
        }else{
            return users.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RowSelected = indexPath.row
        isComplete = true
        print(RowSelected!)
        searchBar.resignFirstResponder()
        self.performSegue(withIdentifier: "ProfileSeg", sender: self)
    }
    
    // Sets the content within each table row cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let userRow = userTableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! UserCell
        //if searching then retunr the results
        if(searching){
            userRow.name?.text = searchingResult[indexPath.row].name
            userRow.username?.text = searchingResult[indexPath.row].username
            userRow.profileImage?.image = URLToImg(URL(string: searchingResult[indexPath.row].profilePic))
            circularImg(imageView: userRow.profileImage.self)
            userRow.selectionStyle = UITableViewCell.SelectionStyle.none
            
        }else{

            userRow.name?.text = users[indexPath.row].name
            userRow.username?.text = users[indexPath.row].username
            userRow.profileImage?.image = URLToImg(URL(string: users[indexPath.row].profilePic))
            circularImg(imageView: userRow.profileImage.self)
            userRow.selectionStyle = UITableViewCell.SelectionStyle.none
        }
        return userRow
    }
    
    //search bar filters based on input
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //if searching for @username or name
        if(searchText.count == 0){
            searching = false
            userTableView.reloadData()
            return
        }
        var searchR = searchText
        if(searchText[searchText.startIndex] == "@" && searchText.count > 1){
            searchR.removeFirst()
            if(searchR.count == 0){
                searchR = ""
            }
            searchingResult = users.filter({$0.username.lowercased().contains( searchR.lowercased()) })
        }else{
                    searchingResult = users.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        }
    
        searching = true
        userTableView.reloadData()
    }
    
    //if cancel then reload data to everything
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        userTableView.reloadData()
    }
    
    // Sets the height of each table cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
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
    
    // Remove keyboard for when the background is tapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if searchBar.isFirstResponder && touch?.view != searchBar
        {
           searchBar.resignFirstResponder()
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ProfileSeg"){
            isComplete = false
            if let nextViewController = segue.destination as? FindPeopleProfileViewController {
                if(searching){
                    nextViewController.user = searchingResult[RowSelected!]
                }else{
                    nextViewController.user = users[RowSelected!]
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "ProfileSeg"){
            return isComplete
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
