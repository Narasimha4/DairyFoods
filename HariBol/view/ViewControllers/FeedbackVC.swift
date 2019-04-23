//
//  FeedbackVC.swift
//  HariBol
//
//  Created by Narasimha on 16/02/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import UIKit

class FeedbackVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    var placeholderLabel : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       submitButton.layerBorder()
        self.title = "Feedback"
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "720X1280_bg")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        textview.layer.borderWidth = 1.0
        textview.layer.borderColor = UIColor.gray.cgColor
        textViewPlaceHolder()
    }
    
    func textViewPlaceHolder()  {
        
        textview.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Please write your feedback"
        placeholderLabel.font = UIFont.systemFont(ofSize: 14.0)
        placeholderLabel.sizeToFit()
        textview.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textview.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.gray
        placeholderLabel.isHidden = !textview.text.isEmpty
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textview.text.isEmpty
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        guard  !textview.text.isEmpty,
            let customerId = UserDefaults.standard.value(forKey: "customerId") as? Int
        else {
            HaribolAlert().alertMsg(message: "Please write your feedback", actionButtonTitle: "OK", title: "HariBol")
            return
        }
        
        let parameters = NSMutableDictionary()
        parameters.setObject(textview.text, forKey: "comments" as NSCopying)
        parameters.setObject(customerId, forKey: "customerId" as NSCopying)
        parameters.setObject("", forKey: "id" as NSCopying)
        parameters.setObject(0, forKey: "rating" as NSCopying)
        parameters.setObject("", forKey: "type" as NSCopying)
        
        HaribolAPI().feedBack(parameters: parameters as! [String : Any], onCompletion: { (response, err) in
            
            if (response!["status"] as? String) != nil {
                let alert = UIAlertController(title: "HariBol", message: "Feedback posted successfully", preferredStyle: .alert)
                let okTapped = UIAlertAction(title: "OK", style: .default) { action in
                    _ = self.navigationController?.popViewController(animated: true)

                }
                alert.addAction(okTapped)
                self.present(alert, animated: true, completion: nil)
            }
        }, onFailure: { (error) in
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
