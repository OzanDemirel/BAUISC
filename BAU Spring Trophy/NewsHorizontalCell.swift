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
        return imageView
    }()
    
    var news: News? {
        didSet {
            newsTitle.text = news?.title
            
            //setNewsImage()
            
        }
    }
    
    let newsTitle: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Futura", size: 12)
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.adjustsFontForContentSizeCategory = true
        textView.textContainer.maximumNumberOfLines = 0
        textView.textColor = UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 1)
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
        
        addSubview(newsTitle)
        addConstraintsWithVisualFormat(format: "H:|-70-[v0]-70-|", views: newsTitle)
        addConstraintsWithVisualFormat(format: "V:|-\(frame.height / 2 + 10)-[v0]-30-|", views: newsTitle)
        addConstraint(NSLayoutConstraint(item: newsTitle, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
    }

}
