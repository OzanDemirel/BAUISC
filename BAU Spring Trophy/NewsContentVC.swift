//
//  NewsContentVC.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 20/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class NewsContentVC: UIViewController {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsText: UITextView!
    
    var homeVC: HomeVC?
    
    var news: News? {
        didSet {

            if let newsText = news?.content {
                
                self.newsText.text = newsText
                
            }

            if let title = news?.title {
                
                newsTitle.text = title
                
            }
            
            setNewsImage()
            
        }
    }
    
    var leftEdgeGesture: UIScreenEdgePanGestureRecognizer!
    var swipeGesture: UISwipeGestureRecognizer!
    
    func setNewsImage() {
        
        if let urlString = news?.imageURL {
            
            if let img = imageCache[urlString] {
                
                newsImage.image = img
                
            } else {
                
                if let url = URL(string: urlString) {
                    
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
                        
                        if error != nil {
                            print(error.debugDescription)
                            return
                        }
                        
                        if let data = data {
                            
                            if let imageFromData = UIImage(data: data) {
                                
                                imageCache.updateValue(imageFromData, forKey: urlString)
                                
                                DispatchQueue.main.async(execute: {
                                    
                                    self.newsImage.image = imageFromData
                                    
                                })
                            }
                            
                        }
                        
                    }).resume()
                    
                }
                
            }

        }
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        newsImage.clipsToBounds = true
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(NewsContentVC.swipeGestureActive))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
        
        leftEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(NewsContentVC.leftEdgeGestureActive(sender:)))
        leftEdgeGesture.edges = .left
        view.addGestureRecognizer(leftEdgeGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        newsText.scrollRectToVisible(CGRect(x: 0, y: 0, width: newsText.frame.width, height: newsText.frame.height), animated: false)
    }
    
    @objc func swipeGestureActive() {
        
        homeVC?.removeNewsContentViewFromView()
        
    }
    

    @objc func leftEdgeGestureActive(sender: UIGestureRecognizer) {

        if sender.state == .began {

            homeVC?.removeNewsContentViewFromView()
            
        }
        
    }


}
