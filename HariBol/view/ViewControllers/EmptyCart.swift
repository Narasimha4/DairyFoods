//
//  EmptyCart.swift
//  HariBol
//
//  Created by Narasimha on 28/03/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import UIKit

protocol Empty {
}

class EmptyCart: UIView {
    
    var delegate:Empty!
    var view : UIView!
    
    @IBOutlet weak var dummyView: UIView!
    
    // Registering the NIB file
    func instanceFromNib() -> UIView {
        return UINib(nibName: "EmptyCart", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    
    // Method initialize Setup
    override init( frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // Coder and decoder setup
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    //MARK:Implementation of  setup method
    func setup(){
        view = instanceFromNib()
        
        addSubview(view)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        updateConstraints()
    }
    
    
}
