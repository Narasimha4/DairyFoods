//
//  PaymentVC.swift
//  HariBol
//
//  Created by Narasimha on 09/02/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import UIKit
import SCLAlertView

class PaymentVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    var data:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.layer.zPosition = 1
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        addButton.clipsToBounds = true

        // Do any additional setup after loading the view.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "720X1280_bg")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
        self.navigationItem.backBarButtonItem?.isEnabled = false
    }
    
    var textField: UITextField?
    
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            self.textField?.placeholder = "Enter amount";
            self.textField?.keyboardType = .numberPad
        }
    }
    
    func openAlertView() {
        UserDefaults.standard.set(1, forKey: "tabbar")
        let alert = UIAlertController(title: "Add Transaction", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler:nil))
        alert.addAction(UIAlertAction(title: "ADD", style: .default, handler:{ (UIAlertAction) in
            self.paymentHandler(amount: self.textField!.text!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPaymentList()
    }
    
    func loginAlertView() {
        let alert = UIAlertController(title: "HariBol", message: "Please Login to Continue.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler:{ (UIAlertAction) in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            guard let delegate = UIApplication.shared.delegate as? AppDelegate  else {
                return
            }
            delegate.window?.rootViewController = UINavigationController(rootViewController: vc)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        return header
    }
    
    private func tableView(_ tableView: UITableView, heightHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let data = data, data.count > 0 else {
            let rect = CGRect(x: 0,
                              y: 0,
                              width: self.tableView.bounds.size.width,
                              height: self.tableView.bounds.size.height)
            let noDataLabel: UILabel = UILabel(frame: rect)
            
            noDataLabel.text = "Please click on + to add  transactions"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle = .none
            return 0
        }
        self.tableView.backgroundView = nil
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PaymentCell
        let dict = data[indexPath.section] as! NSDictionary
        cell.dateLabel.text =  "Date: \(dict.value(forKey:"date") as! String)"
        cell.priceLabel.text = "₹ \(dict.value(forKey:"credit") as! Int)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
    
    
    func getPaymentList() {
        HaribolAPI().getTransactionList(onCompletion: { (response, err) in
            if let response = response, let data = response["data"] as? NSArray {
                self.data = data
                self.tableView.reloadData()
            }
        }, onFailure: { (err) in
        })
    }
    
    func postPayment(parameters:[String:Any]) {
        HaribolAPI().postTransaction(parameters:parameters, onCompletion: { (response, err) in
            print(response!)
            self.getPaymentList()
        }, onFailure: { (err) in
        })
    }
    
    @IBAction func addTapped(_ sender: Any) {
        guard (UserDefaults.standard.value(forKey:"token") as? String) != nil else {
            loginAlertView()
            return
        }
        openAlertView()
       
       /* let appearance = SCLAlertView.SCLAppearance(
            kTextFieldHeight: 40,
            showCloseButton: true
        )
        
        let alert = SCLAlertView(appearance: appearance)
        
        let txt = alert.addTextField("Enter amount")
        _ = alert.addButton("ADD") {
            UserDefaults.standard.set(1, forKey: "tabbar")
            self.paymentHandler(amount: txt.text!)
        }
        let alertViewIcon = UIImage(named: "logo")
        txt.keyboardType = .numberPad
        _ = alert.showEdit("Add Transaction", subTitle: "", closeButtonTitle: "CANCEL", timeout:nil, colorStyle: 0xFF9301, colorTextButton: 0xFFFFFF, circleIconImage: alertViewIcon, animationStyle: .bottomToTop) */
    }
    
    func paymentHandler(amount:String) {
        guard let mobile = UserDefaults.standard.value(forKey: "mobileNumber") as? String else  {
            return
        }
        PayUServiceHelper.sharedManager().getPayment(self ,"mail@mymail.com", mobile, "Simha", amount, "123", didComplete: { (dict, error) in
            if error != nil {
                print("Error")
            }else {
                //Dictionary<AnyHashable,Any>()
                let result = dict?["result"] as? NSDictionary
                let transactionId = result?["txnid"] as? String ?? ""
                //let addedon = result?["addedon"] as? String ?? ""
                let amount = result?["amount"] as? String ?? ""
                guard let customerId = UserDefaults.standard.value(forKey:"customerId") as? Int else {
                    return
                }
                let parameters = ["customerId": "\(customerId)", "amount":amount, "date": self.dateFormatter.string(from: Date()), "details":"PayU Payment", "type":"PAYU", "transactionRef":transactionId]
                self.postPayment(parameters:parameters)
            }
        }) { (error) in
            print("Payment Process Breaked")
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
