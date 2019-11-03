//
//  PostPromotion.swift
//  Voyce
//
//  Created by Student on 10/31/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit

class PostPromotionViewController: UIViewController{
  
  var post:Post = Post(text: "nil", user: User(userID: 0, name: "Pedro", username: "pedro"), likeCount: 0)
  
  @IBOutlet weak var genderTextField: UITextField!
  @IBOutlet weak var adDurationSlider: UISlider!
  
  let rangeSlider = RangeSlider(frame: .zero)

  @IBOutlet weak var AgeRangeLabel: UILabel!
  @IBOutlet weak var adDurationLabel: UILabel!

  
  var lowerAgeRange = 0
  var upperAgeRange = 100
  
  let maxAdDuration = 30
  
  override func viewDidLoad() {
    print(post.text)
    
    super.viewDidLoad()
    view.addSubview(rangeSlider)
    
    //range slider things
    rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)),
                          for: .valueChanged)
    adDurationSlider.value = 1
    adDurationLabel.text = "\(Int(adDurationSlider.value * 30)) seconds"
  }
  
  override func viewDidLayoutSubviews() {
    let margin: CGFloat = 30
    let width = view.bounds.width - 2 * margin
    let height: CGFloat = 10
    
    rangeSlider.frame = CGRect(x: 0, y: 0,width: width, height: height)
    rangeSlider.center = CGPoint(x: view.frame.width/2, y: 210)
    
    
  }
  
  @IBAction func backButtonPressed(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func createAdPressed(_ sender: Any) {
    //need to send information to datdab
//    let alert = UIAlertAction(title: "Post promoted!", style: <#T##UIAlertActionStyle#>, handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
    let alert = UIAlertController(title: "Post promoted!", message: "Your post will now be shown as an Ad.", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ action in
      self.navigationController?.popViewController(animated: true)
      }))
    
    self.present(alert, animated: true)
    print("Should pop")
    
  }
  
  func alertBackHandler(){
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func adDurationSliderChanged(_ sender: Any) {
    print("Ad Duration: \(adDurationSlider.value)")
    adDurationLabel.text = "\(Int(adDurationSlider.value * 30)) seconds"
  }
  
  //range slider
  @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
    let values = "(\(rangeSlider.lowerValue) \(rangeSlider.upperValue))"
    print("Range slider value changed: \(values)")
    lowerAgeRange = Int(rangeSlider.lowerValue * 100)
    upperAgeRange = Int(rangeSlider.upperValue * 100)
    AgeRangeLabel.text = "\(lowerAgeRange)-\(upperAgeRange)"
    print("Range slider values: \(lowerAgeRange), \(upperAgeRange)")
  }
  
}
