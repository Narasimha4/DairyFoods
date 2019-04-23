//
//  VerifyOTPVC.swift
//  HariBol
//
//  Created by Narasimha on 31/12/18.
//  Copyright © 2018 haribol. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class VerifyOTPVC: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var otpField: UITextField!
    let TEXT_FIELD_LIMIT = 6
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        verifyCosmeticSetUp()
        otpField.delegate = self
        guard let mobile = UserDefaults.standard.value(forKey: "mobileNumber") as? String else  {
                return
        }
        let last2 = String(mobile.suffix(2))
        descLabel.text = "OTP sent to XXXXXXXX\(last2)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //An expression works with Swift 2
        return (textField.text?.utf16.count ?? 0) + string.utf16.count - range.length <= TEXT_FIELD_LIMIT
    }
    
    func verifyCosmeticSetUp() {
        otpField.makeBottomBorder()
        verifyButton.layerBorder()
    }
    
    @IBAction func resendOtpTapped(_ sender: Any) {
        
        guard let  mobileNumber = UserDefaults.standard.value(forKey: "mobileNumber") as? String
            else {
                return
        }
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Please wait...", type:.ballRotateChase, fadeInAnimation: nil)
        
        HaribolAPI().validateMobile(number: mobileNumber, onCompletion: { (response, error) in
            DispatchQueue.main.async {
                self.stopAnimating(nil)
            }
            if let token = response?.value(forKey: "token") as? String {
                UserDefaults.standard.set(token, forKey: "token")
            }
            if let otp = response?.value(forKey: "otp") as? Int {
                UserDefaults.standard.set(otp, forKey: "otp")
                self.otpField.text = "\(otp)"
            }
        }, onFailure: { (error) in
            DispatchQueue.main.async {
                self.stopAnimating(nil)
            }
        })
    }
    
    func getProfileDetails() {
        HaribolAPI().getCustomerDetails(onCompletion: { (response, error) in
            if let response = response {
                // Loading dynamic profile Info
                guard let userInfo = response["data"] as? NSDictionary,
                    let customerID = userInfo["customerId"] as? Int
                    else {
                        return
                }
                UserDefaults.standard.set(customerID, forKey: "customerId")
            }
        }, onFailure: { (error) in
        })
    }
 
    
    @IBAction func verifyTapped(_ sender: Any) {
        guard let number = otpField.text, !number.isEmpty
            else {
                HaribolAlert().alertMsg(message: "Please enter otp", actionButtonTitle: "OK", title: "")
                return
        }
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Please wait...", type:.ballRotateChase, fadeInAnimation: nil)
        HaribolAPI().validateOTP(number: Int(number)!, onCompletion: { (response, err) in
            DispatchQueue.main.async {
                self.stopAnimating(nil)
            }
            if let token = response?.value(forKey: "token") as? String {
                UserDefaults.standard.set(token, forKey: "token")
            }
            UserDefaults.standard.set(true, forKey: "verified")
            self.getProfileDetails()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let delegate = UIApplication.shared.delegate as? AppDelegate  else {
                return
            }
            UserDefaults.standard.set(2, forKey: "tabbar")
            delegate.window?.rootViewController = (storyBoard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController)
            delegate.window?.makeKeyAndVisible()
        }, onFailure: { (error) in
            DispatchQueue.main.async {
                self.stopAnimating(nil)
            }
        })        
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
