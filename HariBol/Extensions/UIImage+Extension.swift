//
//  UIImage+Extension.swift
//  HariBol
//
//  Created by Narasimha on 19/02/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}
