//
//  UIImageView+Additions.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/21/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        // Check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            print("cached image")
            completed(cachedImage)
            return
        }
        
        // Otherwise download the image into cache
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if let error = error {
                print(error)
                completed(nil)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    print("downloaded image")
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    completed(downloadedImage)
                }
            }
        }).resume()
    }
    
}
