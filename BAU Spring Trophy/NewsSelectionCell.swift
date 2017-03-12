//
//  NewsSelectionCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 12/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class NewsSelectionCell: BaseCell {
    
    let ellipseView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        if let image = UIImage(named: "EmptyEllipse") {
            imageView.image = image
        }
        if let highlightedImage = UIImage(named: "Ellipse") {
            imageView.highlightedImage = highlightedImage
        }
        return imageView
    }()

    override func setupViews() {
        super.setupViews()
        
        addSubview(ellipseView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: ellipseView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: ellipseView)
        
    }
    
}
