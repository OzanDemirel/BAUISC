//
//  Storage.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 21/04/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

struct defaultsKeys {
    static let imagesKey = "firstStringKey"
    static let filteredImagesKey = "secondStringKey"
    static let filteredImagesForCellKey = "secondStringKey"
    static let raceAnnouncementKey = "secondStringKey"
}

var imageCache = Dictionary<String, UIImage>()

var imageFilterCache = Dictionary<String, UIImage>()

var imageFilterForCellCache = Dictionary<String, UIImage>()

var raceAnnouncementCache = Dictionary<String, Data>()

func saveDatasToStorage() {
    
    if imageCache.count > 0 {
        UserDefaults.standard.set(imageCache, forKey: defaultsKeys.imagesKey)
    }
    
    if imageFilterCache.count > 0 {
        UserDefaults.standard.set(imageFilterCache, forKey: defaultsKeys.filteredImagesKey)
    }
    
    if imageFilterForCellCache.count > 0 {
        UserDefaults.standard.set(imageFilterForCellCache, forKey: defaultsKeys.filteredImagesForCellKey)
    }
    
    if raceAnnouncementCache.count > 0 {
        UserDefaults.standard.set(raceAnnouncementCache, forKey: defaultsKeys.raceAnnouncementKey)
    }
    
}

func loadDatasFromStorage() {
    
    if let data = UserDefaults.standard.dictionary(forKey: defaultsKeys.imagesKey) {
        
        if let images = data as? Dictionary<String, UIImage> {
            imageCache = images
        }
    }
    
    if let data = UserDefaults.standard.dictionary(forKey: defaultsKeys.filteredImagesKey) {
        
        if let filteredImages = data as? Dictionary<String, UIImage> {
            imageFilterCache = filteredImages
        }
    }
    
    if let data = UserDefaults.standard.dictionary(forKey: defaultsKeys.filteredImagesForCellKey) {
        
        if let filteredImagesForCell = data as? Dictionary<String, UIImage> {
            imageFilterForCellCache = filteredImagesForCell
        }
    }
    
    if let data = UserDefaults.standard.dictionary(forKey: defaultsKeys.raceAnnouncementKey) {
        
        if let raceAnnouncement = data as? Dictionary<String, Data> {
            raceAnnouncementCache = raceAnnouncement
        }
    }
    
}




