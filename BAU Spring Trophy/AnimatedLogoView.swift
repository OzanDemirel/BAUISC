//
//  AnimatedLogoView.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 11/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class AnimatedLogoView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @objc func startAnimation() {
        if self.alpha == 0 {
            UIView.animate(withDuration: 1.5, animations: {
                UIView.animate(withDuration: 2, animations: {
                    self.alpha = 1
                }, completion: { (true) in
                    if #available(iOS 10.0, *) {
                        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (_) in
                            self.startAnimation()
                        })
                    } else {
                        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(AnimatedLogoView.startAnimation), userInfo: nil, repeats: false)
                    }
                })
                
            })
        } else {
            UIView.animate(withDuration: 1.5, animations: {
                self.alpha = 0
            }, completion: { (true) in
                if #available(iOS 10.0, *) {
                    _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (_) in
                        self.startAnimation()
                    })
                } else {
                    _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(AnimatedLogoView.startAnimation), userInfo: nil, repeats: false)
                }
            })
        }
        
    }
    
}
