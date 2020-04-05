//
//  FeedViewController.swift
//  Voyce
//
//  Created by Jordan Ghidossi on 2/1/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift

class FeedViewController: UIViewController
{
    @IBOutlet weak var activeCard: Card!
    @IBOutlet weak var queueCard: Card!
    @IBOutlet weak var adVibes: UITextView!
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseManager.shared.loadFeed(view: self)
    }
    
    /// Notifies the view controller that its view is about to be added to a view hierarchy.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// Populate the Feed with an active and queued card with the next available posts.
    func populateFeed() {
        let index = DatabaseManager.shared.index
        let posts = DatabaseManager.shared.posts
        
        switch index % 2 {
        case 0:
            if index < posts.count - 1 {
                self.queueCard.addPost(post: posts[index + 1])
            }
            else {
                self.queueCard.hideCard()
            }
        case 1:
            if index < posts.count - 1 {
                self.activeCard.addPost(post: posts[index + 1])
            }
            else {
                self.activeCard.hideCard()
            }
        default:
            print("Error populating the feed.")
        }
        DatabaseManager.shared.incremementIndex()
    }
    
    // Swipable functionality for activeCard
    @IBAction func panCard(_ sender: UIPanGestureRecognizer)
    {
        let activeCard = sender.view!
        let point = sender.translation(in: view)
        activeCard.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        // Transparency of card
        let xFromCenter = activeCard.center.x - view.center.x
        let yFromCenter = activeCard.center.y - view.center.y
        activeCard.alpha = 1 - abs(xFromCenter) / view.center.x
        
        //Angle of card
        activeCard.transform = CGAffineTransform(rotationAngle: xFromCenter / (view.frame.width / 1.02))
        
        //Bring queueCard to front
        //                for constraint in view.constraints {
        //                    switch constraint.identifier {
        //                    case "queueTop":
        //                        let dist = sqrt(xFromCenter * xFromCenter + yFromCenter * yFromCenter)
        //                        constraint.constant = 17 - (10 * abs(dist / (view.frame.width / 2)))
        //                    case "queueLeft", "queueRight":
        //                        let dist = sqrt(xFromCenter * xFromCenter + yFromCenter * yFromCenter)
        //                        constraint.constant = 20 - (10 * abs(dist / (view.frame.width / 2)))
        //                    case "queueBottom":
        //                        let dist = sqrt(xFromCenter * xFromCenter + yFromCenter * yFromCenter)
        //                        constraint.constant = 30 - (10 * abs(dist / (view.frame.width / 2)))
        //                    case .none:
        //                        break
        //                    case .some(_):
        //                        print("Error: Invalid constraint")
        //                    }
        //                }
        
        // Swipe has ended
        if sender.state == UIGestureRecognizerState.ended {
            // Remove card
            if abs(activeCard.center.x - (view.frame.width / 2)) > 75 || abs(activeCard.center.y - (view.frame.height / 2)) > 100 {
                UIView.animate(withDuration: 0.3, animations: {activeCard.center = CGPoint(x: activeCard.center.x - 200, y: activeCard.center.y + 75)
                    activeCard.alpha = 0
                })
                
                // Load next card
                populateFeed()
                activeCard.center = self.view.center
                activeCard.alpha = 1
                activeCard.transform = CGAffineTransform(rotationAngle: 0)
                
                return
            }
                // Reset card if swipe is premature
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    activeCard.center = self.view.center
                    activeCard.alpha = 1
                    activeCard.transform = CGAffineTransform(rotationAngle: 0)
                })
            }
        }
    }
    
    // Send activeCard data to CommentVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is CommentViewController
        {
            let vc = segue.destination as? CommentViewController
            vc?.activePost = self.activeCard.post
        }
    }
}

////
////  FeedViewController.swift
////  Voyce
////
////  Created by Quinn Ellis on 9/18/19.
////  Copyright © 2019 QEDev. All rights reserved.
////
//
//import UIKit
//
//class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CardDelegate
//{
//    @IBOutlet var tableView: UITableView!
//
//    var limit = 3;
//
//    //Called after the controller's view is loaded into memory.
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UINib(nibName: "CardPic", bundle: nil), forCellReuseIdentifier: "Card")
//        NotificationCenter.default.addObserver(self, selector: #selector(newPosts), name: .NewPosts, object: nil)
//    }
//
//    //Notifies the view controller that its view is about to be added to a view hierarchy.
//    override func viewWillAppear(_ animated: Bool)
//    {
//        super.viewWillAppear(animated)
//        DatabaseManager.shared.loadFeed()
//        if let selectionIndexPath = self.tableView.indexPathForSelectedRow
//        {
//            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
//        }
//    }
//
//    @objc private func newPosts()
//    {
//        print("newPosts reload")
//        tableView.reloadData()
//    }
//
//    // Table view uses CommentCreationViewController, so I did not remove the files --- Aron
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        guard let vc = UIStoryboard(name: "PostCreation", bundle: nil).instantiateViewController(withIdentifier: "CommentCreationVC") as? CommentCreationViewController else
//        {
//            return
//        }
//        vc.post = DatabaseManager.shared.posts[indexPath.row]
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return tableView.frame.height
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if (indexPath.row == DatabaseManager.shared.posts.count - 1) {
//            print("At the end");
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return DatabaseManager.shared.posts.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let card = tableView.dequeueReusableCell(withIdentifier: "Card") as! Card
//        card.fillOut(with: DatabaseManager.shared.posts[indexPath.row])
//        card.delegate = self
//        return card
//    }
//    // Link
//    func profileButtonDidPressed(postUser: User)
//    {
//        if (postUser.userID == DatabaseManager.shared.sharedUser.userID)
//        {
//            self.tabBarController?.selectedIndex = 0
//        }
//        else
//        {
//            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController
//            // ProfileViewController has no user member
////            vc.user = postUser
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let height = scrollView.frame.size.height
//        let contentYoffset = scrollView.contentOffset.y
//        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
//        if distanceFromBottom < height {
//            /* Add something to bottom of post*/
//
//        }
//    }
//}
