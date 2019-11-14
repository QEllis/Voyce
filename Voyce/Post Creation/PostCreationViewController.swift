//
//  PostCreationViewController.swift
//  Voyce
//
//  Created by Quinn Ellis on 10/2/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

class PostCreationViewController: UIViewController {

  @IBOutlet weak var textView: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    textView.layer.cornerRadius = 5
    textView.layer.borderWidth = 1
    textView.layer.borderColor = UIColor.white.cgColor
    textView.text = ""
  }

  @IBAction func postPressed(_ sender: Any) {
    guard !textView.text.isEmpty else { return }
    UserManager.shared.addPost(with: textView.text)
    navigationController?.popViewController(animated: true)
  }

  @IBAction func backPressed(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
}
