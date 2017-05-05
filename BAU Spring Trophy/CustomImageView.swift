//
//  CustomImageView.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 17/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit
import FirebaseStorage

//let imageCache = NSCache<NSString, UIImage>()
//let imageFilterCache = NSCache<NSString, UIImage>()
//let imageFilterForCellCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String!
    
    func loadImageUsingUrlString(_ urlString: String, filterName: String, blendMode: CGBlendMode, alpha: CGFloat, forCell: Bool, _ complete: @escaping (() -> ())) {
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        image = nil
        highlightedImage = nil
        
        if let imageFromCache = imageCache["\(urlString)"]{
            
            highlightedImage = imageFromCache
            
            if forCell {
                if let imageFromFilterCache = imageFilterForCellCache["\(urlString)"] {
                    DispatchQueue.main.async(execute: { 
                        self.image = imageFromFilterCache
                        complete()
                    })
                    return
                }
            } else {
                if let imageFromFilterCache = imageFilterCache["\(urlString)"] {
                    self.image = imageFromFilterCache
                    complete()
                    return
                }
            }
            if self.imageUrlString == urlString {
                
                DispatchQueue.main.async(execute: {
                    
                    let img = self.cropToBounds(image: imageFromCache)
                    
                    if let imageToFilterCache = self.addFilterToImage(baseImage: img, filterName: filterName, blendMode: blendMode, alpha: alpha) {
                        
                        if forCell {
                            imageFilterForCellCache.updateValue(imageToFilterCache, forKey: urlString)
                        } else {
                            imageFilterCache.updateValue(imageToFilterCache, forKey: urlString)
                        }
                        if self.imageUrlString == urlString {
                            self.image = imageToFilterCache
                        }

                    }
                    complete()
                })
            }
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let imageToCache = UIImage(data: data!) {
                    
                    if self.imageUrlString == urlString {
                        self.highlightedImage = imageToCache
                        
                        let img = self.cropToBounds(image: imageToCache)
                        
                        imageCache.updateValue(imageToCache, forKey: urlString)
                        
                        if let imageToFilterCache = self.addFilterToImage(baseImage: img, filterName: filterName, blendMode: blendMode, alpha: alpha) {
                            
                            if self.imageUrlString == urlString {
                                self.image = imageToFilterCache
                            }
                            
                            if forCell {
                                imageFilterForCellCache.updateValue(imageToFilterCache, forKey: urlString)
                            } else {
                                imageFilterCache.updateValue(imageToFilterCache, forKey: urlString)                            }
                        }
                    }
                    
                    complete()
                    
                }

            })
            
        }).resume()
        
    }
    
    func addFilterToImage(baseImage: UIImage, filterName: String, blendMode: CGBlendMode, alpha: CGFloat) -> UIImage? {
        
        if let img2 = UIImage(named: filterName) {
            let rect = frame
            
            if #available(iOS 10.0, *) {
                let renderer = UIGraphicsImageRenderer(size: bounds.size)
                
                let result = renderer.image { ctx in
                    // fill the background with white so that translucent colors get lighter
                    UIColor.white.set()
                    ctx.fill(rect)
                    
                    baseImage.draw(in: rect, blendMode: .normal, alpha: 1)
                    img2.draw(in: rect, blendMode: blendMode, alpha: alpha)
                }
                
                return result
            } else {
                UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
                let context = UIGraphicsGetCurrentContext()
                
                // fill the background with white so that translucent colors get lighter
                context!.setFillColor(UIColor.white.cgColor)
                context!.fill(rect)
                
                baseImage.draw(in: rect, blendMode: .normal, alpha: 1)
                img2.draw(in: rect, blendMode: blendMode, alpha: alpha)
                
                // grab the finished image and return it
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return result
            }
            
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
