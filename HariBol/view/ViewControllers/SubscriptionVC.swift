//
//  SubscriptionVC.swift
//  HariBol
//
//  Created by Narasimha on 02/01/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import UIKit
import DLRadioButton
import SCLAlertView

class SubscriptionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   @IBOutlet weak var subscribeButton: UIButton!
   @IBOutlet weak var tableView: UITableView!
    
    
    var productNames = NSMutableArray()
    var cartCounts = [Int]()
    var productIds = NSMutableArray()
    var productImgs = NSMutableArray()
    var pricelist = [Int]()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up a cool background image for demo purposes
        subscribeButton.layerBorder()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 448
    }
    
    //MARK:Delegate mehod to return number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartCounts.count
    }
    


    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SubscriptionCell
        cell.productName.text = (productNames[indexPath.row] as! String)
        cell.quantity.text = "\(cartCounts[indexPath.row])"
        cell.productImage.contentMode = .scaleAspectFit
        if let url = URL(string: productImgs[indexPath.row] as! String) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return  }
                DispatchQueue.main.async() {
                    cell.productImage.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    
    func customAlert(amount:String, products:[[String:Any]]) {
        let alert = UIAlertController(title: "Total Price: ₹ \(amount)", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler:{ (UIAlertAction) in
            self.paymentHandler(amount:amount, products:products)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func paymentHandler(amount:String, products:[[String:Any]]) {
        guard let mobile = UserDefaults.standard.value(forKey: "mobileNumber") as? String else  {
            return
        }
        PayUServiceHelper.sharedManager().getPayment(self, "mail@mymail.com", mobile, "Simha", amount, "123", didComplete: { (dict, error) in
            if error != nil {
                print("Error")
            }else {
                print("Sucess")
                //Dictionary<AnyHashable,Any>()
                let result = dict?["result"] as? NSDictionary
                let transactionId = result?["txnid"] as? String ?? ""
                //let addedon = result?["addedon"] as? String ?? ""
                let amount = result?["amount"] as? String ?? ""
                guard let customerId = UserDefaults.standard.value(forKey:"customerId") as? Int else {
                    return
                }
                let parameters = ["customerId": "\(customerId)", "amount":amount, "date": self.dateFormatter.string(from: Date()), "details":"PayU Payment", "type":"PAYU", "transactionRef":transactionId]
                HaribolAPI().postSubscriptionDetails(httpMethod: .post, parameters:products , onCompletion: { (response, err) in
                    print(response!)
                    self.postPayment(parameters:parameters)
                }, onFailure: { (err) in
                })
            }
        }) { (error) in
            print("Payment Process Breaked")
        }
    }
    
    private func calculateDaysBetweenTwoDates(start: String, end: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let startDate = dateFormatter.date(from: start)
        let endDate = dateFormatter.date(from: end)
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: startDate!, to: endDate!)
        print ("diff days", differenceOfDate.day! + 1)
        return differenceOfDate.day! + 1
    }
    
    func postProducts() {
        guard let customerId = UserDefaults.standard.value(forKey: "customerId") as? Int else {
            return
        }
        var products = [[String:Any]]()
        var dict =  [String:Any]()
        var totalPrice = 0
        var days = 1
        
        for i in 0...cartCounts.count - 1 {
            var price = 0
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? SubscriptionCell {
                guard  cell.startDateField.text != "" else {
                    HaribolAlert().alertMsg(message: "", actionButtonTitle: "OK", title: "Please select start date")
                    return
                }
                dict["startDate"] = cell.startDateField.text!
                switch cell.once.selected()!.titleLabel!.text! {
                case "Once":
                    dict["frequency"] = 1
                    dict["endDate"] = ""
                    cell.endDateField.text = ""
                case "Daily":
                    guard cell.endDateField.text != "" else {
                        HaribolAlert().alertMsg(message: "", actionButtonTitle: "OK", title: "Please select end date")
                        return
                    }
                    dict["frequency"] = 2
                    dict["endDate"] = cell.endDateField.text!
                case "Alternative":
                    guard cell.endDateField.text != "" else {
                        HaribolAlert().alertMsg(message: "", actionButtonTitle: "OK", title: "Please select end date")
                        return
                    }
                    dict["frequency"] = 3
                    dict["endDate"] = cell.endDateField.text!
                case "Random Days":
                    guard cell.endDateField.text != "" else {
                        HaribolAlert().alertMsg(message: "", actionButtonTitle: "OK", title: "Please select end date")
                        return
                    }
                    dict["frequency"] = 4
                    dict["endDate"] = cell.endDateField.text!
                default:
                    cell.endDateField.text = ""
                    dict["frequency"] = 1
                    dict["endDate"] = ""
                }
                
                if cell.startDateField.text != "" && cell.endDateField.text != ""  {
                    days = calculateDaysBetweenTwoDates(start: cell.startDateField.text!, end: cell.endDateField.text!)
                }
                
                 price = price + cartCounts[i] * pricelist[i] * days
                
                var dates = [String]()
                for button in cell.sunButton.selectedButtons() {
                    dates.append(button.titleLabel!.text!)
                }
                print("dates \(dates)")
                dict["dates"] = dates
                if cell.once.selected()!.titleLabel!.text! == "Random Days" {
                    guard  dates.count > 0 else {
                        HaribolAlert().alertMsg(message: "", actionButtonTitle: "OK", title: "Please select random days")
                        return
                    }
                    price = 0
                    price = price + cartCounts[i] * pricelist[i] * dates.count
                }
            }
            dict["customerId"] = customerId
            dict["productId"] = productIds[i]
            dict["quantity"] = cartCounts[i]
            products.append(dict)
            totalPrice = totalPrice + price
        }
        self.customAlert(amount: "\(totalPrice)", products:products)
    }
    
    func postPayment(parameters:[String:Any]) {
        HaribolAPI().postTransaction(parameters:parameters, onCompletion: { (response, err) in
            print(response!)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tabbar: UITabBarController? = (storyBoard.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController)
            self.present(tabbar!, animated: true, completion: nil)
        }, onFailure: { (err) in
        })
    }
    
    @IBAction func finalizeOrderTapped(_ sender: Any) {
       postProducts()
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


