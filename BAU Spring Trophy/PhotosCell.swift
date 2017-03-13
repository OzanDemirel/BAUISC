//
//  PhotosCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 11/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class PhotosCell: BaseCell {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.darkGray
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        backgroundColor = UIColor.clear
        addSubview(photoImageView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: photoImageView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: photoImageView)
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
