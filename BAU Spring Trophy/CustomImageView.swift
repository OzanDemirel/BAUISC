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
let imageFilterCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(_ urlString: String, filterName: String, blendMode: CGBlendMode, alpha: CGFloat, _ complete: @escaping (() -> ())) {
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        image = nil
        highlightedImage = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString), let imageFromFilterCache = imageFilterCache.object(forKey: urlString as NSString) {
            self.image = imageFromFilterCache
            self.highlightedImage = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let imageToCache = UIImage(data: data!) {
                    
                    let img = self.cropToBounds(image: imageToCache)
                    
                    if self.imageUrlString == urlString {
                        self.highlightedImage = img
                    }
                    
                    imageCache.setObject(img, forKey: urlString as NSString)
                    
                    if let imageToFilterCache = self.addFilterToImage(filterName: filterName, blendMode: blendMode, alpha: alpha) {
                        
                        if self.imageUrlString == urlString {
                            self.image = imageToFilterCache
                        }
                        
                        imageFilterCache.setObject(imageToFilterCache, forKey: urlString as NSString)
                        
                    }
                    
                    complete()
                    
                }

            })
            
        }).resume()
        
    }
    
    func addFilterToImage(filterName: String, blendMode: CGBlendMode, alpha: CGFloat) -> UIImage? {
        
        if let img = highlightedImage, let img2 = UIImage(named: filterName) {
            let rect = frame
            let renderer = UIGraphicsImageRenderer(size: bounds.size)
            
            let result = renderer.image { ctx in
                // fill the background with white so that translucent colors get lighter
                UIColor.white.set()
                ctx.fill(rect)
                
                img.draw(in: rect, blendMode: .normal, alpha: 1)
                img2.draw(in: rect, blendMode: blendMode, alpha: alpha)
            }
            
            return result
            
        }
        return nil
    
    }
    
    func cropToBounds(image: UIImage) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(frame.width)
        var cgheight: CGFloat = CGFloat(frame.height)
        
        let ratio = frame.width / frame.height
        
        // See what size is longer and create the center off of that
        if contextSize.width / ratio > contextSize.height {
            posX = ((contextSize.width - (contextSize.height * ratio)) / 2)
            posY = 0
            cgwidth = contextSize.height * ratio
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - (contextSize.width / ratio)) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width / ratio
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    
}
