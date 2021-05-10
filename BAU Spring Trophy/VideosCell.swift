//
//  VideosCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 11/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class VideosCell: BaseCell {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.darkGray
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let playButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        if let img = UIImage(named: "PlayButton") {
            imageView.image = img
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func setupViews() {
        backgroundColor = UIColor.clear
        addSubview(photoImageView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: photoImageView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: photoImageView)
        
        addSubview(playButtonImageView)
        addConstraint(NSLayoutConstraint(item: playButtonImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: playButtonImageView, attribute: .centerY, relatedBy: .equal, toItem: self,attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: playButtonImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.4, constant: 0))
        addConstraint(NSLayoutConstraint(item: playButtonImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0))
        
    }
    
    func customizeNewsImages(news: Dictionary<String, String>) {
        for (key, value) in news {
            if let image = UIImage(named: "\(value)") {
                photoImageView.image = image
            }
            if let highlightedImage = UIImage(named: "\(key)") {
                photoImageView.highlightedImage = highlightedImage
            }
        }
    }
    
}
