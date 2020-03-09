//
//  PostCreationViewController.swift
//  Voyce
//
//  Created by Quinn Ellis on 10/2/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

class PostCreationViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var imageCaption: UITextView!
    @IBOutlet weak var postSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.white.cgColor
        textView.textColor = UIColor.lightGray
        
        imageCaption.layer.cornerRadius = 5
        imageCaption.layer.borderWidth = 1
        imageCaption.layer.borderColor = UIColor.white.cgColor
        imageCaption.textColor = UIColor.lightGray
        
        postImage.isHidden = true
        imageCaption.isHidden = true
        textView.isHidden = false
        
        textView.delegate = self
        imageCaption.delegate = self
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tap to add text!"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func PostTypeValueChanged(_ sender: Any) {
        switch postSegmentedControl.selectedSegmentIndex {
        case 0:
            textView.isHidden = false
            imageCaption.isHidden = true
            postImage.isHidden = true
            postImage.image = nil
        case 1:
            openImageGallery()
            textView.isHidden = true
            imageCaption.isHidden = false
            postImage.isHidden = false
        default:
            textView.isHidden = false
            imageCaption.isHidden = true
            textView.isHidden = false
        }
        
    }
    
    func openImageGallery() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func postPressed(_ sender: Any) {
        guard !textView.text.isEmpty else { return }
        guard !imageCaption.text.isEmpty else { return }
        switch postSegmentedControl.selectedSegmentIndex {
        case 0:
            //just text post
            DatabaseManager.shared.addPost(with: textView.text)
        case 1:
            DatabaseManager.shared.addPost(with: imageCaption.text, image: "")//add image to url converter
        //add image to the post as well
        default:
            DatabaseManager.shared.addPost(with: textView.text)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension PostCreationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image_data = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        postImage.image = image_data
        let imageURL = info[UIImagePickerControllerImageURL] as! URL
        uploadImage(imageURL: imageURL)
        //                let imageData: Data = UIImagePNGRepresentation(image_data)!
        //                _ = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(imageURL: URL) {
        // Create a root reference
        let storageRef = DatabaseManager.shared.storage.reference()
        
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("images/a.jpg");
        
        // Upload the file to the path
        let uploadTask = imageRef.putFile(from: imageURL, metadata: nil) { metadata, error in guard let metadata = metadata else { return }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in guard let downloadURL = url else { return }
            }
        }
    }
}
