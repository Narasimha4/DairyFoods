//
//  HaribolTabVC.swift
//  HariBol
//
//  Created by Narasimha on 03/02/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import UIKit

class HaribolTabVC: UITabBarController, UITabBarControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let index = UserDefaults.standard.value(forKey: "tabbar") as? Int else {
            self.selectedIndex = 2
            return
        }
       self.selectedIndex = index
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var arrayOfImageNameForSelectedState = ["iCNProfileOn","rupee","unselectedHome","sub", "contact"]
        var arrayOfImageNameForUnselectedState = ["iCNProfile", "rupee", "selectedHome", "sub", "contact"]
        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                
                let imageNameForSelectedState   = arrayOfImageNameForSelectedState[i]
                let imageNameForUnselectedState = arrayOfImageNameForUnselectedState[i]
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysTemplate)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysTemplate)
            }
        }
        
        if let items = self.tabBar.items
        {
            for item in items
            {
                if let image = item.image
                {
                    if self.tabBarController?.selectedIndex == 3 {
                        item.image = image.withRenderingMode( .alwaysOriginal )
                        item.selectedImage = UIImage(named: "iCNActivitiesOn")?.withRenderingMode(.alwaysTemplate)
                    } else if self.tabBarController?.selectedIndex == 0  {
                        item.image = image.withRenderingMode( .alwaysOriginal )
                        item.selectedImage = UIImage(named: "iCNActivities")?.withRenderingMode(.alwaysTemplate)
                    }
                }
            }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
