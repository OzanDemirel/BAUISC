//
//  ContactVC.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 15/04/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class ContactVC: UIViewController {
    
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var addressTextViewHeight: NSLayoutConstraint!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let text = addressTextView.text {
            let size = CGSize(width: addressTextView.frame.width, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            if let font = UIFont(name: "Futura-Book", size: 12) {
                
                let estimatedRect = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: font], context: nil)
                
                if estimatedRect.height > 28.8 {
                    addressTextViewHeight.constant = 60
                    view.layoutIfNeeded()
                }
                
            }
        }
        
        print(addressTextView.contentSize.height)
        print(addressTextView.frame.height)
    }

}
