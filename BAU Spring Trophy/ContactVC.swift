//
//  ContactVC.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 15/04/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit
import MapKit

class ContactVC: UIViewController {
    
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var addressTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contactPageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scrollViewContentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.bounds.height == 480 {
            mapView.isHidden = true
            scrollView.isScrollEnabled = false
        }
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
                    contactPageHeightConstraint.constant += 15
                    scrollViewContentHeightConstraint.constant += 15
                    view.layoutIfNeeded()
                }
                
            }
        }
        
        setMapLocation()
        
    }
    
    func setMapLocation() {
        
        let latitude:CLLocationDegrees = 41.042090
        let longitude:CLLocationDegrees = 29.009072
        
        let latdelta:CLLocationDegrees = 0.01
        let londelta:CLLocationDegrees = 0.01
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latdelta, londelta)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "BAUISC"
        mapView.addAnnotation(annotation)

        
    }
    
    func openWebsite(url: String) {
        
        if let url = URL(string: url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    func openApplication(urlString: String) {
        
        if let url = URL(string: urlString) {
            
            if UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.openURL(url)
                
            } else {
                //redirect to safari because the user doesn't have Instagram
                
                openWebsite(url: urlString)
            }
            
        }
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            openWebsite(url: BAUISC_URL)
            break;
        case 2:
            openWebsite(url: BAHCESEHIR_URL)
            break;
        case 3:
            openApplication(urlString: BAUISC_INSTAGRAM_URL)
            break;
        case 4:
            openApplication(urlString: BAUISC_TWITTER_URL)
            break;
        case 5:
            openApplication(urlString: BAUISC_FACEBOOK_URL)
            break;
        default:
            break;
        }
        
    }

}
