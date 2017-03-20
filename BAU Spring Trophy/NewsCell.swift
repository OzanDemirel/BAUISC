//
//  NewsCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 09/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class NewsCell: BaseCell {
    
    let newsImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var news: News? {
        didSet {
            newsDescription.text = news?.title
            
            //setNewsImage()
        }
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor(red: 251/255, green: 173/255, blue: 24/255, alpha: 1)
        return indicator
    }()
    
    let newsDescription: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Futura", size: 11)
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
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "TrendCellBackground")
        image.contentMode = UIViewContentMode.scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    func setNewsImage() {
        
        if let url = news?.imageURL {
            
            newsImageView.loadImageUsingUrlString(url, filterName: "CellFilter", blendMode: .hue, alpha: 1, {
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
            })
            
        }
        
    }
    

    override func setupViews() {
        
        addSubview(backgroundImage)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: backgroundImage)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: backgroundImage)

        addSubview(activityIndicator)
        addConstraintsWithVisualFormat(format: "H:[v0(20)]", views: activityIndicator)
        addConstraintsWithVisualFormat(format: "V:[v0(20)]", views: activityIndicator)
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        activityIndicator.startAnimating()
        
        addSubview(newsImageView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: newsImageView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: newsImageView)
        
        addSubview(newsDescription)
        addConstraintsWithVisualFormat(format: "H:|-10-[v0]-10-|", views: newsDescription)
        addConstraintsWithVisualFormat(format: "V:|-\(frame.height / 2 + 20)-[v0]-10-|", views: newsDescription)
        addConstraint(NSLayoutConstraint(item: newsDescription, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
    }
    
}
