//
//  ApiService.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 13/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    let ref = FIRDatabase.database().reference()
    let newsString = "news"
    var news = [News]()

    func fetchNews(_ completion: @escaping ([News]) -> ()) {
        
        ref.child(newsString).observe(FIRDataEventType.value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String: AnyObject] {
                self.news = [News]()
                
                for dictionary in data {
                    
                    if let dict = dictionary.value as? [String: AnyObject] {

                        let news = News()
                    
                        if let title = dict["title"] as? String {
                            news.title = title
                        }
                    
                        if let content = dict["content"] as? String {
                            news.content = content
                        }
                    
                        if let order = dict["order"] as? Int {
                            news.order = order
                        }
                    
                        if let url = dict["image"] as? String {
                            news.imageURL = url
                        }
                    
                        self.news.append(news)
                    
                    }
            
                }
                
                self.news = self.news.sorted(by: { $0.order! > $1.order!})
                
                DispatchQueue.main.async(execute: { 
                    completion(self.news)
                })
            } else {
                DispatchQueue.main.async(execute: { 
                    completion([News]())
                })
            }
        })
        
    }
            
    
    
    
//    func fetchData(completion: @escaping (([String]) -> Void)) {
//
//        ref.child("news").queryOrdered(byChild: "order").observe(.value, with: { (news) in
//            
//            print(news)
////            if let news = news.value as? [String:AnyObject] {
//                
////                for value in news {
////                    
////                    if let dict = value.value as? [String:AnyObject] {
////                        
////                        if let order = dict["title"] as? String {
////                            
////                        }
////                        
////                    }
////                    
////                }
////            }
////            print(orders)
//        })
//        
//    }
    
}
