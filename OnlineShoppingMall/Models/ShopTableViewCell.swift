//
//  ShopTableViewCell.swift
//  OnlineShoppingMall
//
//  Created by Admin on 3/25/21.
//  Copyright © 2021 Admin. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

    @IBOutlet weak var shopImg: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopLocation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
