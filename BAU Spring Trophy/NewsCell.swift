//
//  NewsCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 09/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class NewsCell: BaseCell {
    
    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.darkGray
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override func setupViews() {
        backgroundColor = UIColor.clear
        addSubview(newsImageView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: newsImageView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: newsImageView)
        
    }
    
    func customizeNewsImages(news: Dictionary<String, String>) {
        for (key, value) in news {
            if let image = UIImage(named: "\(value)") {
                newsImageView.image = image
            }
            if let highlightedImage = UIImage(named: "\(key)") {
                newsImageView.highlightedImage = highlightedImage
            }
        }
    }
    
}
