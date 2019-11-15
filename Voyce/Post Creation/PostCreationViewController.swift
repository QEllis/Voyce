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
  @IBOutlet weak var postImage: UIImageView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    textView.layer.cornerRadius = 5
    textView.layer.borderWidth = 1
    textView.layer.borderColor = UIColor.white.cgColor
    textView.text = ""
  }
    
    @IBAction func openImageGallery(_ sender: UIButton) {
     
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType =  UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
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

extension PostCreationViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image_data = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        postImage.image = image_data
        
        let imageData:Data = UIImagePNGRepresentation(image_data)!
        let imageStr = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
    }
}
