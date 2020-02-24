//
//  FeedViewController.swift
//  Voyce
//
//  Created by Quinn Ellis on 9/18/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController
{
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //    UserManager.shared.initWithPlaceholderPosts()
        //UserManager.shared.LoadFeed();
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        NotificationCenter.default.addObserver(self, selector: #selector(newPosts), name: .NewPosts, object: nil)
        UserManager.shared.createHardcodedPosts()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //this will reload when you go back to the feed. In the future only reload when user does reload gesture or hits reload button
        UserManager.shared.LoadFeed()
        
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
    
    @IBAction func postPressed(_ sender: Any)
    {
        let vc = UIStoryboard(name: "PostCreation", bundle: nil).instantiateViewController(withIdentifier: "PostCreationVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    
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
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "PostCreation", bundle: nil).instantiateViewController(withIdentifier: "CommentCreationVC") as? CommentCreationViewController else { return }
        vc.post = UserManager.shared.posts[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserManager.shared.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
        cell.fillOut(with: UserManager.shared.posts[indexPath.row])
        cell.delegate = self
        return cell
    }
    
}

extension FeedViewController: PostTableViewCellDelegate {
    func profileButtonDidPressed(postUser: User) {
        if(postUser.userID == UserManager.shared.sharedUser.userID){
            self.tabBarController?.selectedIndex = 1
        } else {
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController
            vc.user = postUser
            navigationController?.pushViewController(vc,animated: true)
        }
    }
}
