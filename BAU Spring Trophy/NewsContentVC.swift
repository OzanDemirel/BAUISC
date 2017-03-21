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
    
    func setNewsImage() {
        
        if let urlString = news?.imageURL {
            
            if let img = imageCache.object(forKey: urlString as NSString) {
                
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
        
        leftEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(TeamInfoVC.leftEdgeGestureActive(sender:)))
        leftEdgeGesture.edges = .left
        view.addGestureRecognizer(leftEdgeGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func leftEdgeGestureActive(sender: UIScreenEdgePanGestureRecognizer) {
        
        if sender.state == .began {

            homeVC?.removeNewsContentViewFromView()
            
        }
        
    }


}
