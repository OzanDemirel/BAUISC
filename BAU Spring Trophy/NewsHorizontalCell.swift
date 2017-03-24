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
            
            setNewsImage()
            
            if #available(iOS 10, *) {
                for i in 0...3 {
                    let height = CGFloat(calculateRequiredLineCount())
                    if height < frame.height / 2 - 30 {
                        newsTitleHeightConstraint.constant = (height <= (frame.height / 2 - 30)) ? height : (frame.height / 2 - 30)
                        break
                    } else {
                        let size = 14 - i
                        newsTitle.font = UIFont(name: "Futura-Bold", size: CGFloat(size))
                    }
                }
            } else {
                removeConstraint(newsTitleHeightConstraint)
                addConstraint(NSLayoutConstraint(item: newsTitle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: frame.height / 2 - 30))
            }
        }
    }

    var newsTitleHeightConstraint: NSLayoutConstraint!
    
    let newsTitle: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Futura-Bold", size: 14)
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOpacity = 1
        textView.layer.shadowRadius = 1
        textView.layer.shadowOffset = CGSize(width: 0, height: 0)
        textView.textContainer.maximumNumberOfLines = 0
        textView.textColor = UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 1)
        return textView
    }()
    
    func setNewsImage() {
        
        if let url = news?.imageURL {
        
            newsImageView.loadImageUsingUrlString(url, filterName: "TrendNewsFilter", blendMode: .hue, alpha: 1, forCell: false, {
                
            })
            
        }
        
    }
    
    func calculateRequiredLineCount() -> Int {
        var lineCount = 0;
        let textSize = CGSize(width: frame.width - 140, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(newsTitle.sizeThatFits(textSize).height))
        let charSize = lroundf(Float((newsTitle.font?.lineHeight)!))
        lineCount = rHeight/charSize
        return (lineCount * charSize)
    }

    override func setupViews() {
        
        addSubview(newsImageView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: newsImageView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: newsImageView)
        
        addSubview(newsTitle)
        addConstraintsWithVisualFormat(format: "H:|-70-[v0]-70-|", views: newsTitle)
        addConstraint(NSLayoutConstraint(item: newsTitle, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -30))
        newsTitleHeightConstraint = NSLayoutConstraint(item: newsTitle, attribute: .height, relatedBy: .equal, toItem: newsTitle, attribute: .height, multiplier: 1, constant: frame.height / 2 - 30)
        addConstraint(newsTitleHeightConstraint)
        
    }

}
