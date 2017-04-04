//
//  PhotosCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 11/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class PhotosCell: BaseCell {
    
    var photo: Photo? {
        didSet {
            if !activityIndicator.isAnimating {
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            }
            setPhotosImage()
        }
    }
    
    let photoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor(red: 251/255, green: 173/255, blue: 24/255, alpha: 1)
        return indicator
    }()
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "TrendCellBackground")
        image.contentMode = UIViewContentMode.scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    func setPhotosImage() {
        
        if let url = photo?.imageURL {
            
            photoImageView.loadImageUsingUrlString(url, filterName: "CellFilter", blendMode: .hue, alpha: 1, forCell: true, {
                
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
        
        addSubview(photoImageView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: photoImageView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: photoImageView)
    }

}
