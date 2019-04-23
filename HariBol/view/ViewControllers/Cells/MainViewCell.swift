//
//  MainViewCell.swift
//  HariBol
//
//  Created by Narasimha on 13/02/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import UIKit

class MainViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
