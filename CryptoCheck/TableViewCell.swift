//
//  TableViewCell.swift
//  CryptoCheck
//
//  Created by Adam Eliezerov on 3/5/18.
//  Copyright © 2018 labbylabs. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var posnegArrow: UIImageView!
    @IBOutlet weak var percentChange: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
