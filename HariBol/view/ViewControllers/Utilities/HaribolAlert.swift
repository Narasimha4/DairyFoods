//
//  HaribolAlert.swift
//  HariBol
//
//  Created by Narasimha on 06/01/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import Foundation
import UIKit


class HaribolAlert {
    
    // AlertView Function
    func alertMsg(message: String, actionButtonTitle: String, title: String) {
        DispatchQueue.main.async {
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: actionButtonTitle, style: .default, handler: nil))
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = UIViewController()
            window.windowLevel = UIWindow.Level.alert
            window.makeKeyAndVisible()
            window.rootViewController?.present(alertView, animated: false, completion: nil)
        }
    }
}
