//
//  customCellTwo.swift
//  PantryAid
//
//  Created by AdminNick on 11/5/16.
//  Copyright © 2016 AdminNick. All rights reserved.
//

import UIKit

class customCellTwo: UITableViewCell {

    @IBOutlet var imageThumbnail: UIImageView!
    @IBOutlet var groceryLabel: UILabel!
    
    @IBOutlet var addGroceryButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
