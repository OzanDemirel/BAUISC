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
    
    var ref = FIRDatabase.database().reference()
    
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
