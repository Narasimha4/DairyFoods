//
//  SubscriptionCell.swift
//  HariBol
//
//  Created by Narasimha on 27/02/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import UIKit
import DLRadioButton

class SubscriptionCell: UITableViewCell {
    
    @IBOutlet weak var sunButton: DLRadioButton!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateIndicator: UIButton!
    @IBOutlet weak var startDateIndicator: UIButton!
    @IBOutlet weak var daysView: UIView!
    @IBOutlet weak var once: DLRadioButton!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cosmeticSetup()
        
    }
    
    func cosmeticSetup() {
        endDateField.layer.borderColor = UIColor.black.cgColor
        endDateField.layer.borderWidth = 2.0
        startDateField.layer.borderColor = UIColor.black.cgColor
        startDateField.layer.borderWidth = 2.0
        endDateField.setLeftPaddingPoints(5)
        startDateField.setLeftPaddingPoints(5)
        showStartDatePicker(textField:startDateField)
        showEndDatePicker(textField:endDateField)
        endDateField.isHidden = true
        endDateIndicator.isHidden = true
        daysView.isHidden = true
        once.isSelected = true
        
        self.sunButton.isMultipleSelectionEnabled = true;
    }
    
    func showStartDatePicker(textField:UITextField) {
        //Formate Date
        startDatePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let  doneButton:UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDatePick));
        startDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value:2 , to:Date())
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        textField.inputAccessoryView = toolbar
        textField.inputView = startDatePicker
    }
    
    func showEndDatePicker(textField:UITextField) {
        //Formate Date
        endDatePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let  doneButton:UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endDatePick));
        endDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value:7 , to:Date())
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        textField.inputAccessoryView = toolbar
        textField.inputView = endDatePicker
    }
    
    @objc func startDatePick() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        startDateField.text = formatter.string(from: startDatePicker.date)
        self.endEditing(true)
    }
    
    @objc func endDatePick() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        endDateField.text = formatter.string(from: endDatePicker.date)
        self.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.endEditing(true)
    }
    
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is 22 selected.\n", button.titleLabel!.text!));
            }
        } else {
            print(String(format: "%@ is selected.\n", radioButton.selected()!.titleLabel!.text!));
            switch radioButton.selected()!.titleLabel!.text! {
            case "Once": 
                endDateField.isHidden = true
                endDateIndicator.isHidden = true
                daysView.isHidden = true
            case "Daily", "Alternative":
                daysView.isHidden = true
                endDateField.isHidden = false
                endDateIndicator.isHidden = false
            case "Custom Days":
                daysView.isHidden = false
                endDateField.isHidden = false
                endDateIndicator.isHidden = false
            default:()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
