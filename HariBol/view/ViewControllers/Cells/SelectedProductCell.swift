//
//  SelectedProductCell.swift
//  HariBol
//
//  Created by Narasimha on 10/02/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import UIKit

class SelectedProductCell: UITableViewCell {
    
    var minusButtonobj : (() -> Void)? = nil
    var plusButtonobj : (() -> Void)? = nil

    @IBOutlet weak var cartLabel: UILabel!
    @IBOutlet weak var plusTapped: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cosmeticSetUp()
    }
    
    @IBAction func plusTapped(_ sender: Any) {
        if let plusTapped = self.plusButtonobj {
            plusTapped()
        }
    }
    
    func cosmeticSetUp() {
        roundShape(button: minusButton)
        roundShape(button: plusTapped)
    }
    
    func roundShape(button:UIButton) {
        button.layer.cornerRadius = minusButton.frame.size.width / 2
        button.clipsToBounds = true
        button.layer.borderWidth = 2.0
        button.layer.borderColor  = UIColor.init(red: 79/255, green: 107/255, blue: 144/255, alpha: 1.0).cgColor
    }
    
    @IBAction func minusTapped(_ sender: Any) {
        if let minusTapped = self.minusButtonobj {
            minusTapped()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
