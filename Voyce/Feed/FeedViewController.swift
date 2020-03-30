//
//  FeedViewController.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/18/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CardDelegate
{
    @IBOutlet var tableView: UITableView!
    
    var limit = 3;
    
    //Called after the controller's view is loaded into memory.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CardPic", bundle: nil), forCellReuseIdentifier: "Card")
        NotificationCenter.default.addObserver(self, selector: #selector(newPosts), name: .NewPosts, object: nil)
    }
    
    //Notifies the view controller that its view is about to be added to a view hierarchy.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        DatabaseManager.shared.loadFeed()
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow
        {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    @objc private func newPosts()
    {
        print("newPosts reload")
        tableView.reloadData()
    }
    
    // Table view uses CommentCreationViewController, so I did not remove the files --- Aron
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let vc = UIStoryboard(name: "PostCreation", bundle: nil).instantiateViewController(withIdentifier: "CommentCreationVC") as? CommentCreationViewController else
        {
            return
        }
        vc.post = DatabaseManager.shared.posts[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == DatabaseManager.shared.posts.count - 1){
            print("At the end");
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return DatabaseManager.shared.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let card = tableView.dequeueReusableCell(withIdentifier: "Card") as! Card
        card.fillOut(with: DatabaseManager.shared.posts[indexPath.row])
        card.delegate = self
        return card
    }
    // Link
    func profileButtonDidPressed(postUser: User)
    {
        if (postUser.userID == DatabaseManager.shared.sharedUser.userID)
        {
            self.tabBarController?.selectedIndex = 0
        }
        else
        {
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController
            // ProfileViewController has no user member
//            vc.user = postUser
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            /* Add something to bottom of post*/
            
        }
    }
}

// ------------------------------- To be used later -------------------------------
    
//    @IBAction func postPressed(_ sender: Any)
//    {
//        let vc = UIStoryboard(name: "PostCreation", bundle: nil).instantiateViewController(withIdentifier: "PostCreationVC")
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    
    
//    override func awakeFromNib()
//    {
//        super.awakeFromNib()
//        let touchTest = UITapGestureRecognizer(target: self, action: #selector(self.testTap(sender:)))
//        testingLabel.isUserInteractionEnabled = true
//        testingLabel.addGestureRecognizer(touchTest)
//    }
    
    
//    @IBAction func panCard(_ sender: UIPanGestureRecognizer)
//    {
//        let card = sender.view!
//        let point = sender.translation(in: view)
//        let xFromCenter = card.center.x - view.center.x
//
//        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
//
//        if xFromCenter > 0 {
//
//        }
//
//
//        if sender.state == UIGestureRecognizerState.ended {
//
//            if card.center.x > view.frame.width + 75 {
//                UIView.animate(withDuration: 0.3, animations: {card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
//                    card.alpha = 0
//                })
//                return
//            }
//            else if card.center.x > view.frame.width - 75 {
//                UIView.animate(withDuration: 0.3, animations: {card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
//                    card.alpha = 0
//                })
//                return
//            }
//            else {
//                UIView.animate(withDuration: 0.2, animations: {card.center = self.view.center})
//            }
//        }
//    }
