//
//  AccountInfoVC.swift
//  HariBol
//
//  Created by Narasimha on 31/12/18.
//  Copyright © 2018 haribol. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AccountInfoVC: UIViewController {

    @IBOutlet weak var fnameField: UITextField!
    @IBOutlet weak var lnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "HARIBOL"
        accountInfoCosmetics()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    
    func accountInfoCosmetics(){
        fnameField.makeBottomBorder()
        lnameField.makeBottomBorder()
        emailField.makeBottomBorder()
        updateButton.layerBorder()
    }
    
    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let fname = fnameField.text, !fname.isEmpty,
            let lname = lnameField.text, !lname.isEmpty,
            let email = emailField.text, !email.isEmpty
            else {
                HaribolAlert().alertMsg(message: "Please fill all the fields", actionButtonTitle: "OK", title: "")
                return false
        }
        
        guard isValidEmail(testStr: email) else {
            HaribolAlert().alertMsg(message: "Please enter valid email address", actionButtonTitle: "OK", title: "")
            return false
        }
        
        UserDefaults.standard.set(fname, forKey: "fname")
        UserDefaults.standard.set(lname, forKey: "lname")
        UserDefaults.standard.set(email, forKey: "email")
        return true
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
