//
//  FirebaseUtil.swift
//  Voyce
//
//  Created by Frank  on 10/29/19.
//  Copyright © 2019 QEDev. All rights reserved.
//

import Foundation
import UIKit

func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}

func downloadImage(from url: URL, imageView: UIImageView) {
    print("Download Started")
    getImageData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        print(response?.suggestedFilename ?? url.lastPathComponent)
        print("Download Finished")
        DispatchQueue.main.async() {
            imageView.image = UIImage(data: data)
        }
    }
}
