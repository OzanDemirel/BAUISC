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
            newsTitle.text = news?.title
            
            //setNewsImage()
            
            let height = CGFloat(calculateRequiredLineCount())
            newsTitleHeightConstraint.constant = (height <= (frame.height / 2 - 5)) ? height : (frame.height / 2 - 5)
        }
        
    }
    
    var newsTitleHeightConstraint: NSLayoutConstraint!
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor(red: 251/255, green: 173/255, blue: 24/255, alpha: 1)
        return indicator
    }()
    
    let newsTitle: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Futura-Bold", size: 12)
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOpacity = 1
        textView.layer.shadowRadius = 1
        textView.layer.shadowOffset = CGSize(width: 0, height: 0)
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.sizeToFit()
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
            
            newsImageView.loadImageUsingUrlString(url, filterName: "CellFilter", blendMode: .hue, alpha: 1, forCell: true, {
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
            })
            
        }
        
    }
    
    func calculateRequiredLineCount() -> Int {
        var lineCount = 0;
        let textSize = CGSize(width: frame.width - 10, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(newsTitle.sizeThatFits(textSize).height))
        let charSize = lroundf(Float((newsTitle.font?.lineHeight)!))
        lineCount = rHeight/charSize
        return lineCount * charSize
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

        addSubview(newsTitle)
        addConstraint(NSLayoutConstraint(item: newsTitle, attribute: .bottom, relatedBy: .equal, toItem: newsImageView, attribute: .bottom, multiplier: 1, constant: -5))
        addConstraintsWithVisualFormat(format: "H:|-5-[v0]-5-|", views: newsTitle)
        
        //height constraint
        newsTitleHeightConstraint = NSLayoutConstraint(item: newsTitle, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: frame.height / 2)
        addConstraint(newsTitleHeightConstraint!)
        
    }
    
}
