
//
//  CommentCreationViewController.swift
//  Voyce
//
//  Created by Quinn Ellis on 10/19/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

class CommentCreationViewController: UIViewController {

  @IBOutlet weak var textView: UITextView!

  var post: Post?

  override func viewDidLoad() {
    super.viewDidLoad()
    textView.layer.cornerRadius = 5
    textView.layer.borderWidth = 1
    textView.layer.borderColor = UIColor.white.cgColor
    textView.text = "Type here!"
  }

  @IBAction func postPressed(_ sender: Any) {
    guard !textView.text.isEmpty, let post = post else { return }
    UserManager.shared.addComment(with: textView.text, post: post)
    navigationController?.popViewController(animated: true)
  }

}
