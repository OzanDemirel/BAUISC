//
//  RaceAnnouncementContainer.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 07/04/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit
import WebKit

class RaceAnnouncementContainer: BaseCell {
    
    var webView: WKWebView = {
        let web = WKWebView()
        web.contentMode = UIViewContentMode.scaleAspectFit
        return web
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor(red: 1/255, green: 85/255, blue: 139/255, alpha: 1)
        return indicator
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(webView)
        addConstraintsWithVisualFormat(format: "H:|[v0]|", views: webView)
        addConstraintsWithVisualFormat(format: "V:|[v0]|", views: webView)
        
        addSubview(activityIndicator)
        addConstraintsWithVisualFormat(format: "H:[v0(40)]", views: activityIndicator)
        addConstraintsWithVisualFormat(format: "V:[v0(40)]", views: activityIndicator)
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        activityIndicator.startAnimating()
        
        if let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/bauisc-a520b.appspot.com/o/raceAnnouncement%2FBAU%20I%CC%87LKBAHAR%20TROFESI%CC%87%208%20Nisan%20Yar%C4%B1s%CC%A7%20I%CC%87lan%C4%B1_SON.pdf?alt=media&token=28d18817-b794-4509-bd74-487a5c1ab411") {
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                if let data = data {
                    DispatchQueue.main.async(execute: {
                        self.webView.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: url.deletingLastPathComponent())
                        self.activityIndicator.stopAnimating()
                    })

                }
                
            }).resume()

        }
        
    }
    
}
