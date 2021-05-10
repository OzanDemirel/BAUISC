//
//  RaceRouteCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 05/05/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class RouteCardCell: PhotosCell {
    
    var urlString: String? {
        didSet {
            if !activityIndicator.isAnimating {
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            }
            setPhotosImage()
        }
    }
    
    var title: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 1)
        label.font = UIFont(name: "Futura-Bold", size: 12)
        label.textAlignment = .left
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 1
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        //label.attributedText = NSAttributedString(string: "ROTA 1", attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleDouble.rawValue])
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(title)
        addConstraintsWithVisualFormat(format: "V:|[v0(30)]", views: title)
        addConstraintsWithVisualFormat(format: "H:|-10-[v0]|", views: title)
        
    }
    
    override func setPhotosImage() {
        
        if let url = urlString {
            
            photoImageView.loadImageUsingUrlString(url, filterName: "CellFilter", blendMode: .hue, alpha: 1, forCell: true, {
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
            })
            
        }
    }
    
}
