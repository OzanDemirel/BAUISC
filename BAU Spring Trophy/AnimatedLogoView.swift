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
    
    func startAnimation() {
        
        if self.alpha == 0 {
            UIView.animate(withDuration: 1.5, animations: {
                UIView.animate(withDuration: 2, animations: {
                    self.alpha = 1
                }, completion: { (true) in
                    _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (_) in
                        self.startAnimation()
                    })
                })
                
            })
        } else {
            UIView.animate(withDuration: 1.5, animations: {
                self.alpha = 0
            }, completion: { (true) in
                _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (_) in
                    self.startAnimation()
                })
            })
        }
        
    }
    
}
