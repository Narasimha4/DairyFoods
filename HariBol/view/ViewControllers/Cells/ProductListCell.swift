//
//  SubscriptionCell.swift
//  HariBol
//
//  Created by Narasimha on 02/01/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import UIKit

class ProductListCell: UITableViewCell {
    
    var addButtonobj : (() -> Void)? = nil
    var minusButtonobj : (() -> Void)? = nil
    var plusButtonobj : (() -> Void)? = nil

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cartLabel: UILabel!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    
    @IBAction func minusTapped(_ sender: Any) {
        if let minusTapped = self.minusButtonobj {
            minusTapped()
        }
    }
    
    @IBAction func plusTapped(_ sender: Any) {
        if let plusTapped = self.plusButtonobj {
            plusTapped()
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        if let addTapped = self.addButtonobj {
            addTapped()
        }
    }
    
    func roundShape(button:UIButton) {
        button.layer.cornerRadius = minusButton.frame.size.width / 2
        button.clipsToBounds = true
        button.layer.borderWidth = 2.0
        button.layer.borderColor  = UIColor.init(red: 79/255, green: 107/255, blue: 144/255, alpha: 1.0).cgColor
    }
    
    func cosmeticSetUp() {
        roundShape(button: minusButton)
        roundShape(button: plusButton)
        cartLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cosmeticSetUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
