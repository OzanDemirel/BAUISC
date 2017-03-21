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
    
    var ads: Ads? {
        didSet {
            if let adCount = ads?.imagesURL?.count {
                self.adCount = adCount
            }
            fetchImages { 
                print("done")
                print(self.ads?.images?.count)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func fetchImages(_ completion: @escaping () -> ()) {
        
        for i in 0...(adCount - 1) {
         
            if let url = URL(string: (ads?.imagesURL?[i])!) {
             
                URLSession.shared.dataTask(with: url, completionHandler: { (data, respond, error) in
                    
                    if error != nil {
                        print(error.debugDescription)
                        return
                    }
                    
                    if let data = data {
                     
                        if let image = UIImage(data: data) {
                         
                            if self.ads?.imagesURL?.count == i {
                             
                                self.ads?.images?.append(image)
                                
                            } else {
                                return
                            }
                        }
                    }
                })
            }
        }
    }
}
