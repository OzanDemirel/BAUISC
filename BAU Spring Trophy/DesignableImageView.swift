//
//  MainMenuButton.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 08/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableImageView: UIImageView {
    
    @IBInspectable var shadowOpacity: Float = 1 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadious: CGFloat = 3 {
        didSet {
            layer.shadowRadius = shadowRadious
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 2.0, height: 2.0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.darkGray {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height + 2)).cgPath
        layer.shouldRasterize = true
//        layer.shadowPath = CGPath(rect: CGRect(x: 0, y: 2, width: frame.width, height: frame.height), transform: nil)
    }
    
}


//layer.shadowOpacity = 1
//layer.shadowRadius = 4.0
//layer.shadowOffset = CGSize(width: 2.0, height: 3.0)
//layer.shadowColor = UIColor.darkGray.cgColor
