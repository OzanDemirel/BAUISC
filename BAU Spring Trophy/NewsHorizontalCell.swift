//
//  NewsHorizontalCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 12/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class NewsHorizontalCell: BaseCell {
    
    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.darkGray
        if let image = UIImage(named: "ScrollViewNewsFilter") {
            imageView.image = image
        }
        if let highlightedImage = UIImage(named: "ScrollViewNews") {
            imageView.highlightedImage = highlightedImage
        }
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let newsDescription: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Futura-Medium", size: 15)
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.text = "BAUISC Yelkencilik Programları Başladı.."
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.textColor = UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 1)
        textView.textContainer.maximumNumberOfLines = 2
        return textView
    }()
    
    override func setupViews() {
        
        addSubview(newsImageView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: newsImageView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: newsImageView)
        
        addSubview(newsDescription)
        addConstraintsWithVisualFormat(format: "H:[v0(\(frame.width / 2))]", views: newsDescription)
        addConstraintsWithVisualFormat(format: "V:|-\(frame.height / 2 + 10)-[v0]-40-|", views: newsDescription)
        addConstraint(NSLayoutConstraint(item: newsDescription, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
    }

}
