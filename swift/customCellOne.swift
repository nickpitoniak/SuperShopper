//
//  customCellOne.swift
//  PantryAid
//
//  Created by AdminNick on 11/5/16.
//  Copyright © 2016 AdminNick. All rights reserved.
//

import UIKit

class customCellOne: UITableViewCell {

    
    @IBOutlet var deleteGroceryButton: UIButton!
    
    @IBOutlet var imageThumbnail: UIImageView!
    @IBOutlet var groceryNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
