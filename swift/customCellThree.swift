//
//  customCellThree.swift
//  PantryAid
//
//  Created by AdminNick on 11/6/16.
//  Copyright © 2016 AdminNick. All rights reserved.
//

import UIKit

class customCellThree: UITableViewCell {

    @IBOutlet var brandImageView: UIImageView!

    @IBOutlet var productImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
