//
//  AdsBanner.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 21/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class AdsBanner: UIImageView {

//    var adCount = 0
//    var imageCount = 0
//    var adsOrder: [AdsOrder]?
    var addressURL: String?
    
    var ads: Ads? {
        didSet {
            if let addressURL = ads?.addressURL {
                self.addressURL = addressURL
            }
            fetchImages {}
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
//    func animateBanner() {
//        if let timeInterval = ads?.fps {
//            _ = Timer.scheduledTimer(withTimeInterval: timeInterval / 100, repeats: true, block: { (timer) in
//                if self.imageCount == self.adCount {
//                    if self.imageCount > (self.ads?.currentAd)! {
//                        self.changeImage()
//                    } else {
//                        self.ads?.currentAd = 0
//                        self.changeImage()
//                    }
//                }
//            })
//        }
//    }
//    
//    func changeImage() {
//        if let currentAd = self.ads?.currentAd {
//            if currentAd < self.adCount {
//                if let ad = self.adsOrder?[currentAd] {
//                    if let urlString = ad.imageURL {
//                        ads?.currentAd += 1
//                        DispatchQueue.main.async(execute: { 
//                            self.image = self.imageCache.object(forKey: urlString as NSString)
//                        })
//                    }
//                }
//            }
//        }
//    }
    
    let imageCache = NSCache<NSString, UIImage>()
    
    func fetchImages(_ completion: @escaping () -> ()) {
        
        if let urlString = ads?.imageURL {
            
            if let url = URL(string: urlString) {
                
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print(error.debugDescription)
                        return
                    }
                    
                    if let data = data {
                        
                        if let image = UIImage(data: data) {
                            self.imageCache.setObject(image, forKey: urlString as NSString)
                            DispatchQueue.main.async(execute: {
                                self.image = image
                            })
                        }
                    }
                }).resume()
            }
        }
        completion()
    }
}
