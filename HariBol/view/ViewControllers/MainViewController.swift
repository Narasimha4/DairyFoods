//
//  MainViewController.swift
//  HariBol
//
//  Created by Narasimha on 26/12/18.
//  Copyright © 2018 haribol. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, iCarouselDataSource, iCarouselDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var pageControl: UIPageControl!
    var banners = NSArray()
    var info = NSArray()
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add a background view to the table view
        
        displayBanners()
        
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        addButton.clipsToBounds = true
        
        carousel!.type = .linear
        carousel!.delegate = self
        carousel.isPagingEnabled = true
        carousel.bounces = false
        //welcome PagControl
        pageControl.currentPage = 0
        carousel!.reloadData()
        
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: true)
        
        let backgroundImage = UIImage(named: "720X1280_bg")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleToFill
        tableView.backgroundView = imageView
    }
    
    @objc func handleTimer() {
        var newIndex = self.carousel.currentItemIndex + 1
        
        if newIndex > self.carousel.numberOfItems {
            newIndex = 0
        }
        carousel.scrollToItem(at: newIndex, duration: 0.5)
    }
    
    private func tableView(_ tableView: UITableView, heightHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func displayBanners() {
        HaribolAPI().getBanner(onCompletion: { (response, error) in
            if let response = response {
            guard let response = response["data"] as? NSDictionary, let banners = response["images"] as? NSArray, let messeges = response["messages"] as? NSArray else  {
               return
            }
            self.info = messeges
            self.banners = banners
            self.tableView.reloadData()
            self.carousel!.reloadData()
            }
        }, onFailure: { (error) in
            
        })
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainViewCell
        cell.titleLabel.text = ((info[indexPath.section] as! NSDictionary).value(forKey: "title") as! String)
        cell.descLabel.text = (info[indexPath.section] as! NSDictionary).value(forKey: "description") as? String
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 2.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .wrap:
            return 1
        default:
            return value
        }
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        pageControl.currentPage = carousel.currentItemIndex
    }
    
    //MARK: Number of items in iCarousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        return banners.count
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    //MARK: Manipulating iCarousel view
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let imageView = UIView(frame: CGRect(x: 0, y: 0, width: carousel.frame.size.width, height: carousel.frame.size.height))
        let image = UIImageView(frame: imageView.frame)
        image.contentMode = .scaleAspectFit
        if let url = URL(string: (banners[index] as? String)!) {
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return  }
                DispatchQueue.main.async() {
                    image.image = UIImage(data: data)
                }
            }
        }
        imageView.addSubview(image)
        pageControl.layer.zPosition = 1
        return imageView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserDefaults.standard.set(2, forKey: "tabbar")
        guard (UserDefaults.standard.value(forKey:"token") as? String) != nil else {
            loginAlertView()
            return
        }
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
    
}

