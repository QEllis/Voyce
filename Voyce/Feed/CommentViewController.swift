//
//  CommentViewController.swift
//  Voyce
//
//  Created by Jordan Ghidossi on 3/22/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift

class CommentViewController: UIViewController
{
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var commentFeed: UITableView!
    
    var activePost: Post!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadContent()
    }
    
    private func loadContent() {
        switch activePost.postType {
        case "text":
            break
        case "image":
            let url = URL(string: activePost.content)
            if url != nil {
                let data = try? Data(contentsOf: url!)
                self.postImage.image = UIImage(data: data!)
            }
        case "video":
            break
        default:
            print("Error: Unknown Post Type for \(activePost.postID)")
        }
    }
}
