//
//  AdsBanner.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 21/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class AdsBanner: UIImageView {

    var adCount = 0
    var imageCount = 0
    var adsOrder: [AdsOrder]?
    
    var ads: Ads? {
        didSet {
            if let adCount = ads?.order.count {
                self.adCount = adCount
                print(self.adCount)
            }
            fetchImages {
                if let adsOrder = self.ads?.order {
                    self.adsOrder = adsOrder
                }
                self.animateBanner()
                print(self.imageCount)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func animateBanner() {
        if let timeInterval = ads?.fps {
            _ = Timer.scheduledTimer(withTimeInterval: timeInterval / 100, repeats: true, block: { (timer) in
                if self.imageCount == self.adCount {
                    if self.imageCount > (self.ads?.currentAd)! {
                        self.changeImage()
                    } else {
                        self.ads?.currentAd = 0
                        self.changeImage()
                    }
                }
            })
        }
    }
    
    func changeImage() {
        if let currentAd = self.ads?.currentAd {
            if currentAd < self.adCount {
                if let ad = self.adsOrder?[currentAd] {
                    if let urlString = ad.imageURL {
                        ads?.currentAd += 1
                        DispatchQueue.main.async(execute: { 
                            self.image = self.imageCache.object(forKey: urlString as NSString)
                        })
                    }
                }
            }
        }
    }
    
    let imageCache = NSCache<NSString, UIImage>()
    
    func fetchImages(_ completion: @escaping () -> ()) {
        
        for i in 0...(adCount - 1) {
         
            if let urlString = ads?.order[i].imageURL {
                
                if let url = URL(string: urlString) {
                    
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, respond, error) in
                        
                        if error != nil {
                            print(error.debugDescription)
                            return
                        }
                        
                        if let data = data {
                            print(self.imageCount)
                            
                            if let image = UIImage(data: data) {
                                self.imageCache.setObject(image, forKey: urlString as NSString)
                                self.imageCount += 1
                                DispatchQueue.main.async(execute: {
                                    self.image = image
                                })
                            }
                        }
                    }).resume()
                }
            }
        }
        completion()
    }
}
