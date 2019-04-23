//
//  FSCalendarScopeViewController.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 30/12/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import UIKit
import FSCalendar

class FSCalendarScopeExampleViewController: UIViewController,  FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cartBarButton: BadgeBarButtonItem!
    
    var total = 0
    var responseArray = NSArray()
    var totalResponse = NSDictionary()
    @IBOutlet weak var updateOrder: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    var OrderedList:Ordered_Base!
    var emptyCart: EmptyCart = UINib(nibName: "EmptyCart", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmptyCart
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = nil
        arrowDown()
        updateOrder.layerBorder()
        
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        addButton.clipsToBounds = true
        // Removing the navigation bar border
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        // FSCalendarMonthPosition.previous
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "720X1280_bg")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
        updateOrder.layer.zPosition = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getOrderedList(date:self.dateFormatter.string(from: Date()))
        self.navigationItem.rightBarButtonItem = nil
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
    
    func getOrderedList(date:String) {
        HaribolAPI().getOrderedList(date:date, onCompletion: { (data, response, error) in
            self.responseArray = response!["data"] as! NSArray
            self.totalResponse = response!
            print(response!)
            if let data = data {
                self.generateOrderedList(with: data)
            }
        }, onFailure: { (error) in
        })
    }
    
    func generateOrderedList(with data:Data) {
        do {
            OrderedList = try JSONDecoder().decode(Ordered_Base.self, from:data)
            tableView.reloadData()
        } catch {
            print("Error: While parsing orders")
        }
    }
    
    deinit {
        print("\(#function)")
    }
    @IBAction func updateOrderTapped(_ sender: Any) {
        var parametr = [[String: Any]]()
        var dict = [String: Any]()
        for i in 0...(OrderedList.data?.count)! - 1 {
            let indexPath = IndexPath(row: 0, section: i)
            if let cell = tableView.cellForRow(at: indexPath) as? SelectedProductCell {
                if cell.cartLabel.text != "" {
                    ((self.responseArray[i] as? NSDictionary)!.mutableCopy() as? NSMutableDictionary)!.setObject(Int(cell.cartLabel.text!)!, forKey: "orderQuantity" as NSCopying)
                }
            }
        }
        dict = ["data":self.responseArray]
        parametr.append(dict)
        HaribolAPI().postSubscriptionDetails(httpMethod: .put, parameters: parametr, onCompletion: { (response, err) in
        }, onFailure: { (err) in
        })
    }
    
    func arrowDown() {
        let image = UIImage(named: "down")?.withRenderingMode(.alwaysTemplate)
        arrowButton.setImage(image, for: .normal)
        arrowButton.tintColor = UIColor.white
    }
    
    func arrowUp() {
        let image = UIImage(named: "up")?.withRenderingMode(.alwaysTemplate)
        arrowButton.setImage(image, for: .normal)
        arrowButton.tintColor = UIColor.white
    }
    
    // MARK:- UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                arrowDown()
                return velocity.y < 0
            case .week:
                arrowUp()
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        getOrderedList(date: self.dateFormatter.string(from: date))
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    // MARK:- UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if OrderedList != nil, (OrderedList.data?.count)! > 0 {
            tableView.separatorStyle = .singleLine
            updateOrder.isHidden = false
            emptyCart.isHidden = true
            tableView.backgroundView = nil
            return (OrderedList.data?.count)!
        } else {
            tableView.backgroundView  = emptyCart
            emptyCart.isHidden = false
            emptyCart.layer.zPosition = 1
            updateOrder.isHidden = true
            return 0
        }
    }
    
    private func tableView(_ tableView: UITableView, heightHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
    //MARK:Delegate mehod to return number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (OrderedList.data?.count)! > 0 else {
            return 0
        }
        return 1
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectedProductCell
        let orders = OrderedList.data![indexPath.section]
        cell.productLabel.text = orders.productName
        cell.cartLabel.text = "\(orders.orderQuantity!)"
        if let image = orders.productImage, let url = URL(string:image) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return  }
                DispatchQueue.main.async() {
                    cell.productImage.image = UIImage(data: data)
                }
            }
        } else {
            cell.productImage.image = UIImage.init(named: "gallery")
        }
        var cartItem = orders.orderQuantity!
        cell.minusButtonobj = {
            cartItem = cartItem - 1
            cell.cartLabel.text = "\(cartItem)"
            self.total = self.total - 1
            if cartItem < orders.orderQuantity! {
                cartItem = orders.orderQuantity!
                cell.cartLabel.text = "\(cartItem)"
                if self.total == 0 {
                    self.navigationItem.rightBarButtonItem = nil
                }
            } else {
                // self.navigationItem.rightBarButtonItem = self.cartBarButton
            }
            //self.cartBarButton.badgeNumber = self.total
        }
        
        cell.plusButtonobj = {
            // self.navigationItem.rightBarButtonItem = self.cartBarButton
            cartItem = cartItem + 1
            //self.cartBarButton.badgeNumber = cartItem
            self.total = self.total + 1
            //self.cartBarButton.badgeNumber = self.total
            cell.cartLabel.text = "\(cartItem)"
        }
        return cell
    }
    
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
            self.calendar.setScope(scope, animated: true)
        }
    }
    
    // MARK:- Target actions
    @IBAction func toggleClicked(sender: AnyObject) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
            arrowDown()
        } else {
            self.calendar.setScope(.month, animated: true)
            arrowUp()
        }
    }
    
    @IBAction func addSubscription(_ sender: Any) {
        guard (UserDefaults.standard.value(forKey:"token") as? String) != nil else {
            loginAlertView()
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserDefaults.standard.set(2, forKey: "tabbar")
    }
    
}
