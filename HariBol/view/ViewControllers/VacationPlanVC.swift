//
//  VacationPlanVC.swift
//  HariBol
//
//  Created by Narasimha on 04/03/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import UIKit

class VacationPlanVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var startField: UITextField!
    @IBOutlet weak var endField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Vacation plan"
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "720X1280_bg")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
        cosmeticSetup()
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        
        guard let startDate = endField.text, !startDate.isEmpty,
            let endDate = endField.text, !endDate.isEmpty
            else {
                HaribolAlert().alertMsg(message: "Please select the vacation period", actionButtonTitle: "OK", title: "HariBol")
                return
        }
        
        guard let customerId = UserDefaults.standard.value(forKey: "customerId") else {
            return
        }
        
        let parameters = ["customerId":customerId, "endDate":endField.text! , "startDate":startField.text!]
        HaribolAPI().vacationPlan(parameters: parameters, onCompletion: { (response, error) in
            let alert = UIAlertController(title: "HariBol", message: "Vacation period selected.", preferredStyle: .alert)
            let okTapped = UIAlertAction(title: "OK", style: .default) { action in
                _ = self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okTapped)
            self.present(alert, animated: true, completion: nil)
        }, onFailure: { (err) in
        })
    }
    
    func cosmeticSetup() {
        submitButton.layerBorder()
        submitButton.layer.cornerRadius = 5.0
        endField.layer.borderColor = UIColor.black.cgColor
        endField.layer.borderWidth = 1.0
        endField.layer.cornerRadius = 5.0
        startField.layer.borderColor = UIColor.black.cgColor
        startField.layer.borderWidth = 1.0
        startField.layer.cornerRadius = 5.0
        endField.setLeftPaddingPoints(5)
        startField.setLeftPaddingPoints(5)
        showStartDatePicker()
        showEndDatePicker()
    }
    
    func showStartDatePicker() {
        //Formate Date
        startDatePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let  doneButton:UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDatePick));
        startDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value:0 , to:Date())
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        startField.inputAccessoryView = toolbar
        startField.inputView = startDatePicker
    }
    
    func showEndDatePicker() {
        //Formate Date
        endDatePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let  doneButton:UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endDatePick));
        endDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value:1 , to:Date())
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        endField.inputAccessoryView = toolbar
        endField.inputView = endDatePicker
    }
    
    @objc func startDatePick() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        startField.text = formatter.string(from: startDatePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func endDatePick() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        endField.text = formatter.string(from: endDatePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
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
