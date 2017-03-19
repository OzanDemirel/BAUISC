//
//  NewsHorizontalCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 12/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class NewsHorizontalCell: BaseCell {
    
    let newsImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var news: News? {
        didSet {
            newsDescription.text = news?.title
            
            setNewsImage()
        }
    }
    
    let newsDescription: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Futura-Medium", size: 15)
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.textColor = UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 1)
        textView.textContainer.maximumNumberOfLines = 2
        return textView
    }()
    
    func setNewsImage() {
        
        if let url = news?.imageURL {
        
            newsImageView.loadImageUsingUrlString(url, filterName: "TrendNewsFilter", blendMode: .multiply, alpha: 0.8, {
                
            })
            
        }
        
    }

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
