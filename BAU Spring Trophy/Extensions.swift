//
//  Extensions.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 11/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraintsWithVisualFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

extension UIViewController {
    
    func calculateAnimationDuration(startingPoint: CGPoint, destinationPoint: CGPoint) -> TimeInterval {
        
        if abs(startingPoint.x - destinationPoint.x) >= abs(startingPoint.y - destinationPoint.y) {
            return abs(TimeInterval(startingPoint.x - destinationPoint.x)) / abs(TimeInterval((startingPoint.x - destinationPoint.x) * 1.5))
        } else {
            return abs(TimeInterval(startingPoint.y - destinationPoint.y)) / abs(TimeInterval((startingPoint.y - destinationPoint.y) * 1.5))
        }
        
    }
    
}
