//
//  CollapsibleProductsVC.swift
//  HariBol
//
//  Created by Narasimha on 09/02/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import UIKit

class CollapsibleProductsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var barButton: BadgeBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var listCount = 0
    var products = [String]()
    var productList:Products_Base!
    var total = 0
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func getproductsList() {
        HaribolAPI().getProductsList(onCompletion: { (data, response, error) in
            if let data = data {
                self.generateProductList(with: data)
            }
        }, onFailure: { (error) in
        })
    }
    
    func generateProductList(with data:Data) {
        do {
            productList = try JSONDecoder().decode(Products_Base.self, from:data)
            for data in productList.data! {
                products.append(data.name!)
            }
            print(products)
            tableView.reloadData()
        } catch {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getproductsList()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "720X1280_bg")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @IBAction func cartTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:Delegate method to return title in header section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45; // space b/w cells
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.layer.borderColor = UIColor.black.cgColor
        header.layer.borderWidth = 1.5
        header.layer.cornerRadius = 1.0
        header.backgroundColor = UIColor.clear
        let frame = tableView.frame
        let button = UIButton(frame:CGRect(x: 0, y: 0, width: frame.size.width, height: 45))
        button.tag = section
        button.setTitle(products[section], for: .normal)
        button.setTitleColor(UIColor.orange, for: .normal)
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        header.addSubview(button)
        return header
    }
    
    @objc func buttonTapped(sender:UIButton) {
        print("Button Clicked",sender.tag)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func numberOfSections(in tableView: UITableView) -> Int  {
        listCount = products.count
        if listCount == 0 {
            let rect = CGRect(x: 0,
                              y: 0,
                              width: self.tableView.bounds.size.width,
                              height: self.tableView.bounds.size.height)
            let noDataLabel: UILabel = UILabel(frame: rect)
            noDataLabel.numberOfLines = 0
            noDataLabel.text = "Our services are not available in your location. We will expand our services shortly."
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle = .none
            return 0
        } else {
            self.tableView.backgroundView = nil
            return products.count
        }
    }
    
    //MARK:Delegate mehod to return number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard productList != nil, let list = productList.data![section].products else {
                let rect = CGRect(x: 0,
                                  y: 0,
                                  width: self.tableView.bounds.size.width,
                                  height: self.tableView.bounds.size.height)
                let noDataLabel: UILabel = UILabel(frame: rect)
                noDataLabel.numberOfLines = 0
                noDataLabel.text = "Our services are not available in your location. We will expand our services shortly."
                noDataLabel.textColor = UIColor.black
                noDataLabel.textAlignment = NSTextAlignment.center
                self.tableView.backgroundView = noDataLabel
                self.tableView.separatorStyle = .none
                return 0
        }
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
        return list.count
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductListCell
        let product = productList.data![indexPath.section].products![indexPath.row]
        cell.productName.text = product.name
        cell.productPrice.text = "₹" + "\(product.basePrice!)"
        cell.addButton.layerBorder()
        cell.productImage.contentMode = .scaleAspectFit
        if let image = product.image, let url = URL(string:image) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return  }
                DispatchQueue.main.async() {
                    cell.productImage.image = UIImage(data: data)
                }
            }
        } else {
            cell.productImage.image = UIImage.init(named: "gallery")
        }
        cell.addButton.isHidden = false
        cell.cartView.isHidden = true
        var cartItem = 1
        cell.addButtonobj = {
            cell.addButton.isHidden = true
            cell.cartView.isHidden = false
            cell.cartLabel.text = "\(cartItem)"
            self.navigationItem.rightBarButtonItem = self.barButton
            self.total = self.total + 1
            self.barButton.badgeNumber = self.total

        }
        cell.minusButtonobj = {
            cartItem = cartItem - 1
            cell.cartLabel.text = "\(cartItem)"
            self.total = self.total - 1
            if cartItem < 1 {
                cell.addButton.isHidden = false
                cell.cartView.isHidden = true
                cartItem = 1
                cell.cartLabel.text = ""
                if self.total == 0 {
                    self.navigationItem.rightBarButtonItem = nil
                }
            } else {
                self.navigationItem.rightBarButtonItem = self.barButton
            }
            self.barButton.badgeNumber = self.total
        }
        cell.plusButtonobj = {
            self.navigationItem.rightBarButtonItem = self.barButton
            cartItem = cartItem + 1
            cell.cartLabel.text = "\(cartItem)"
            self.barButton.badgeNumber = cartItem
            self.total = self.total + 1
            self.barButton.badgeNumber = self.total
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let prodictIds = NSMutableArray()
        var cartItems = [Int]()
        let products = NSMutableArray()
        let productImgs = NSMutableArray()
        var pricelist = [Int]()
        for i in 0...listCount - 1 {
            let indexPath = IndexPath(row: 0, section: i)
            let product = productList.data![i].products![0]
            if let cell = tableView.cellForRow(at: indexPath) as? ProductListCell {
                if cell.cartLabel.text != "" {
                    cartItems.append(Int(cell.cartLabel.text!)!)
                    products.add(cell.productName.text!)
                    prodictIds.add(product.productId!)
                    pricelist.append(product.basePrice!)
                    if let image = product.image {
                        productImgs.add(image)
                    } else {
                        productImgs.add("gallery")
                    }
                }
            }
        }
        print(pricelist)
        if(segue.identifier == "SubscriptionVC"){
            let subsciptionVC = segue.destination as! SubscriptionVC
            subsciptionVC.productNames = products
            subsciptionVC.cartCounts = cartItems
            subsciptionVC.productIds = prodictIds
            subsciptionVC.pricelist = pricelist
            subsciptionVC.productImgs = productImgs
        }
    }
}

