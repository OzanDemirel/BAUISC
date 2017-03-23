//
//  SideMenuCell.swift
//  BAU Spring Trophy
//
//  Created by Ozan Demirel on 08/03/2017.
//  Copyright © 2017 BAUISC. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var headline: UILabel!
    var seperatorBar: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIScreen.main.bounds.width == 320 {
            headline.font = UIFont(name: "Futura", size: 11)
        }

    }
    
    func setupCell(menuItem: Dictionary<String, String>) {
        
        for (keys, values) in menuItem {
            headline.text = keys
            if let image = UIImage(named: values) {
                icon.image = image
            }
        }
        
        seperatorBar = UIImageView(frame: CGRect(x: 0, y: layer.frame.height - 1, width: layer.frame.width, height: 1))
        seperatorBar.backgroundColor = UIColor(red: 249/255, green: 185/255, blue: 24/255, alpha: 0.6)
        addSubview(seperatorBar)
        
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        
//
//        // Configure the view for the selected state
//    }
//    
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        
//        
//    }


}
