//
//  CustomImageView.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 17/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit
import FirebaseStorage

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(_ urlString: String) {
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let imageToCache = UIImage(data: data!) {
                    
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    
                    imageCache.setObject(imageToCache, forKey: urlString as NSString)
                    
                }

            })
            
        }).resume()
    }
    
}

//let imageCache = NSCache<NSString, UIImage>()
//
//class CustomImageView: UIImageView {
//    
//    var imageUrlString: String?
//    
//    func loadImageUsingUrlString(_ urlString: String) {
//        
//        imageUrlString = urlString
//        image = nil
//        
//        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
//            self.image = imageFromCache
//            return
//        }
//        
//        FIRStorage.storage().reference().child("Content10.jpeg").data(withMaxSize: 2 * 1024 * 1024) { (data, error) in
//            
//            
//            if error != nil {
//                print(error.debugDescription)
//                return
//            }
//            
//            DispatchQueue.main.async(execute: {
//                
//                let imageToCache = UIImage(data: data!)
//                
//                if self.imageUrlString == "10" {
//                    self.image = imageToCache
//                }
//                
//                imageCache.setObject(imageToCache!, forKey: "10" as NSString)
//            })
//            
//        }
//
//    }
//    
//}
