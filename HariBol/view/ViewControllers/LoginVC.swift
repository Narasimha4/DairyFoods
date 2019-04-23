//
//  LoginVC.swift
//  HariBol
//
//  Created by Narasimha on 26/12/18.
//  Copyright © 2018 haribol. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class LoginVC: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var proceedButton: UIButton!
    let TEXT_FIELD_LIMIT = 10
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 254/255, green: 155/255, blue: 37/255, alpha: 1.0)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @IBAction func skipLoginTapped(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let delegate = UIApplication.shared.delegate as? AppDelegate  else {
            return
        }
        UserDefaults.standard.set(2, forKey: "tabbar")
        delegate.window?.rootViewController = (storyBoard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController)
        delegate.window?.makeKeyAndVisible()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginCosmetics()
    }
    
    func loginCosmetics()  {
        mobileNumber.makeBottomBorder()
        mobileNumber.delegate = self
        proceedButton.layerBorder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //An expression works with Swift 2
        return (textField.text?.utf16.count ?? 0) + string.utf16.count - range.length <= TEXT_FIELD_LIMIT
    }
    
    @IBAction func proceedTapped(_ sender: Any) {
        
        let size = CGSize(width: 30, height: 30)
        guard let number = mobileNumber.text, !number.isEmpty
            else {
                HaribolAlert().alertMsg(message: "Please enter your mobile number", actionButtonTitle: "OK", title: "HariBol")
                return
        }
        
        if mobileNumber.text!.count == TEXT_FIELD_LIMIT {
            startAnimating(size, message: "Please wait...", type:.ballRotateChase, fadeInAnimation: nil)
            UserDefaults.standard.set(mobileNumber.text!, forKey: "mobileNumber")
            HaribolAPI().validateMobile(number: mobileNumber.text!, onCompletion: { (response, error) in
                print(response!)
                DispatchQueue.main.async {
                    self.stopAnimating(nil)
                }
                self.performSegue(withIdentifier: "VerifyOTPVC", sender: self)
            }, onFailure: { (error) in
                DispatchQueue.main.async {
                    self.stopAnimating(nil)
                }
                self.performSegue(withIdentifier: "AccountInfoVC", sender: self)
            })
        } else {
            HaribolAlert().alertMsg(message: "Please enter valid mobile number", actionButtonTitle: "OK", title: "HariBol")
        }
    }
}

