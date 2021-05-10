//
//  DesignableButton.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 26.10.2020.
//  Copyright © 2020 BAUISC. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableButton: UIButton {
    
    var isActive: Bool = false {
        didSet {
            if self.isActive && (self.accessibilityIdentifier == "ircTeams" || self.accessibilityIdentifier == "orcTeams") {
                NotificationCenter.default.post(name: NSNotification.Name("raitingTypeSelectedInTeamsPage"), object: nil)
            } else if self.isActive && (self.accessibilityIdentifier == "IRC" || self.accessibilityIdentifier == "ORC") {
                let identifierDataDict:[String: String] = ["identifier": self.accessibilityIdentifier ?? ""]
                if self.accessibilityIdentifier != ApiService.sharedInstance.selectedRaitingType {
                    NotificationCenter.default.post(name: NSNotification.Name("raitingTypeSelectedInResultsPage"), object: nil, userInfo: identifierDataDict)
                }
                
                //ApiService.sharedInstance.selectedRaitingType = self.accessibilityIdentifier ?? ""
            }
        }
    }

    @IBInspectable var shadowOpacity: Float = 1 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadious: CGFloat = 3 {
        didSet{
            layer.shadowRadius = shadowRadious
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 2.0, height: 2.0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shouldRasterize = true
    }
}
