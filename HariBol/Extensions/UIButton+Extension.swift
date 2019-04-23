//
//  UIButton+Extension.swift
//  HariBol
//
//  Created by Narasimha on 31/12/18.
//  Copyright © 2018 haribol. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func layerBorder() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0
    }
}
