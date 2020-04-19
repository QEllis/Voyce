//
//  PostCreationViewController.swift
//  Voyce
//
//  Created by Quinn Ellis on 10/2/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import UIKit

class PostCreationViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var imageCaption: UITextView!
    @IBOutlet weak var postSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad()
    {
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
    
    // Removes text field when the background is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if textView.isFirstResponder && touch?.view != textView
        {
            textView.resignFirstResponder()
        }
        super.touchesBegan(touches, with: event)
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
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func postPressed(_ sender: Any) {
        guard !textView.text.isEmpty else { return }
        guard !imageCaption.text.isEmpty else { return }
        //var post = Post()
        //it is a text post
        if(postSegmentedControl.selectedSegmentIndex == 0){
            let caption = textView.text!
            DatabaseManager.shared.createPost(ImageURL: "", postType: "text", caption: caption)
        }else if(postSegmentedControl.selectedSegmentIndex == 1){ // image post
            //DatabaseManager.shared.uploadPost(image: postImage);
        }else{ //video post
            
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

           let image_data = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage)!
           postImage.image = image_data
           let imageURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.imageURL)] as! URL
           uploadImage(imageURL: imageURL)
           //                let imageData: Data = UIImagePNGRepresentation(image_data)!
           //                _ = imageData.base64EncodedString()
           self.dismiss(animated: true, completion: nil)
       }
       
       func uploadImage(imageURL: URL)
       {
           // Create a root reference
           let storageRef = DatabaseManager.shared.storage.reference()
           
           // Create a reference to the file you want to upload
           let imageRef = storageRef.child("images/a.jpg");
           
           // Upload the file to the path
        _ = imageRef.putFile(from: imageURL, metadata: nil) { metadata, error in guard let metadata = metadata else { return }
               // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
               // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in guard url != nil else { return }
               }
           }
    }
}
        
        

//        // Create the file metadata
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        // Upload file and metadata to the object 'images/mountains.jpg'
//        let uploadTask = storageRef.putFile(from: imageURL, metadata: metadata)
//
//        // Listen for state changes, errors, and completion of the upload.
//        uploadTask.observe(.resume) { snapshot in
//          // Upload resumed, also fires when the upload starts
//        }
//
//        uploadTask.observe(.pause) { snapshot in
//          // Upload paused
//        }
//
//        uploadTask.observe(.progress) { snapshot in
//          // Upload reported progress
//          let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
//            / Double(snapshot.progress!.totalUnitCount)
//        }
//
//        uploadTask.observe(.success) { snapshot in
//          // Upload completed successfully
//        }
//
//        uploadTask.observe(.failure) { snapshot in
//          if let error = snapshot.error as? NSError {
//            switch (StorageErrorCode(rawValue: error.code)!) {
//            case .objectNotFound:
//              // File doesn't exist
//              break
//            case .unauthorized:
//              // User doesn't have permission to access file
//              break
//            case .cancelled:
//              // User canceled the upload
//              break
//
//            /* ... */
//
//            case .unknown:
//              // Unknown error occurred, inspect the server response
//              break
//            default:
//              // A separate error occurred. This is a good place to retry the upload.
//              break
//            }
//          }
//        }


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
