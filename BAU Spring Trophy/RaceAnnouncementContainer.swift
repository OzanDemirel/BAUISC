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
        
        fetchAccouncementURL()
        
    }
    
    func fetchAccouncementURL() {
        
        ApiService.sharedInstance.fetchRaceAnnouncement { (url) in
            self.fetchAnnouncementData(urlString: url)
        }
        
    }
    
    func fetchAnnouncementData(urlString: String) {
        
        if let data = raceAnnouncementCache[urlString], let url = URL(string: urlString) {
            
            self.webView.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: url.deletingLastPathComponent())
            self.activityIndicator.stopAnimating()
            return
        }
        
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                if let data = data {
                    
                    raceAnnouncementCache.updateValue(data, forKey: urlString)
                    
                    DispatchQueue.main.async(execute: {
                        self.webView.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: url.deletingLastPathComponent())
                        self.activityIndicator.stopAnimating()
                    })
                    
                }
                
            }).resume()
            
        }
        
    }
    
}
