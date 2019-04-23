//
//  ProfileVC.swift
//  HariBol
//
//  Created by Narasimha on 03/02/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ProfileVC: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
  
    
    var editBarButtonItem:UIBarButtonItem!
    var profileResponse:NSDictionary?
    let picker = UIImagePickerController()
    var isEdit: Bool = true
    
    @IBOutlet weak var addressField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImage(named: "720X1280_bg")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFit
        tableView.backgroundView = imageView
        
        nameField.delegate = self
        mailField.delegate = self
        phoneField.delegate = self
        addressField.delegate = self
        nameField.addDoneOnKeyboardWithTarget(self, action: #selector(doneButtonClicked))
        mailField.addDoneOnKeyboardWithTarget(self, action: #selector(doneButtonClicked))
        phoneField.addDoneOnKeyboardWithTarget(self, action: #selector(doneButtonClicked))
        addressField.addDoneOnKeyboardWithTarget(self, action: #selector(doneButtonClicked))
        profileFieldSetup(bool: false)
        picker.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.connected(_:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        editBarButtonItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem  = editBarButtonItem
    }
    
    @objc func editTapped(){
        if isEdit  {
            isEdit = false
            profileFieldSetup(bool: true)
            self.navigationItem.rightBarButtonItem! = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(editTapped))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        } else {
            editMethod()
        }
    }
    
    func editMethod()  {
        isEdit = true
        profileFieldSetup(bool: false)
        self.navigationItem.rightBarButtonItem! = UIBarButtonItem(title: "Edit", style: .plain, target: self, action:  #selector(editTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        updateProfile()
    }
    
    func changetitle(title:String) {
        let item = self.navigationItem.rightBarButtonItem!
        let button = item.customView as! UIButton
        button.setTitle(title, for: .normal)
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        editMethod()
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       // editMethod()
    }
    
    func share(message: String, link: String) {
        if let link = NSURL(string: link) {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @objc func connected(_ sender:AnyObject){
        let actionSheetController = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        let uplaodPicAction = UIAlertAction(title: "Choose Photo", style: .default) { action -> Void in
            self.uploadFromLibrary()
        }
        
        actionSheetController.addAction(uplaodPicAction)
        let choosePicAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            self.takePhoto()
        }
        actionSheetController.addAction(choosePicAction)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in
        }
        actionSheetController.addAction(cancel)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneField {
            return (textField.text?.utf16.count ?? 0) + string.utf16.count - range.length <= 10
        } else {
            return true
        }
    }
    
    func updateProfile() {
        
        if let profileResponse = profileResponse?.mutableCopy() as? NSMutableDictionary {
            if nameField.text!.count > 1 {
                profileResponse.setObject(nameField.text!, forKey: "firstName" as NSCopying)
            } else {
                HaribolAlert().alertMsg(message: "Please enter your name", actionButtonTitle: "OK", title: "")
            }
            
            guard isValidEmail(testStr: mailField.text!) else {
                HaribolAlert().alertMsg(message: "Please enter valid email address", actionButtonTitle: "OK", title: "")
                return
            }
            
            profileResponse.setObject(mailField.text!, forKey: "email" as NSCopying)
            
            if phoneField.text!.count == 10 {
                profileResponse.setObject(phoneField.text!, forKey: "phone" as NSCopying)
            } else {
                HaribolAlert().alertMsg(message: "Please enter valid mobile number", actionButtonTitle: "OK", title: "")
            }
             profileResponse.setObject(addressField.text!, forKey: "address2" as NSCopying)
            HaribolAPI().updateProfile(parameters: profileResponse as! [String:Any], onCompletion: { (response, error) in
                print(response!)
            }, onFailure: { (error) in
                
            })
        }
    }
    
    func uploadFromLibrary() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func takePhoto()  {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        UserDefaults.standard.set(0, forKey: "tabbar")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        UserDefaults.standard.set(0, forKey: "tabbar")
        profileImage.image = selectedImage
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        if let profileResponse = profileResponse?.mutableCopy() as? NSMutableDictionary {
            profileResponse.setObject(selectedImage.toBase64()!, forKey: "image" as NSCopying)
            print(profileResponse)
            HaribolAPI().updateProfile(parameters: profileResponse as! [String:Any], onCompletion: { (response, error) in
                print(response!)
            }, onFailure: { (error) in
                
            })
        }
        dismiss(animated:true, completion: nil)
    }
    
    func profileFieldSetup(bool:Bool) {
        nameField.isEnabled = bool
        mailField.isEnabled = bool
        phoneField.isEnabled = bool
        addressField.isEnabled = bool
        nameField.becomeFirstResponder()
    }
    
 
    @IBAction func addressTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let addressVC = storyBoard.instantiateViewController(withIdentifier: "AddressVC") as? AddressVC
        addressVC?.navflow = "AddressVC"
        UserDefaults.standard.set(0, forKey: "tabbar")
        let navController = UINavigationController(rootViewController: addressVC!)
        navController.navigationBar.barTintColor = UIColor.init(red: 254/255, green: 155/255, blue: 37/255, alpha: 1.0)
        flowVar = "address"
        self.present(navController, animated: true, completion: nil)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProfileDetails()
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
    
    
    func getProfileDetails() {
        HaribolAPI().getCustomerDetails(onCompletion: { (response, error) in
            if let response = response {
                self.cosmeticSetup(response:response as! [String : Any])
                self.profileResponse = (response["data"] as! NSDictionary)
            }
        }, onFailure: { (error) in
        })
    }
    
    func cosmeticSetup(response:[String:Any]) {
        
        print(response)
        
        // Loading dynamic profile Info
        guard let userInfo = response["data"] as? NSDictionary,
            let lName = userInfo["lastName"] as? String,
            let fName = userInfo["firstName"] as? String,
            let mobileNumber = userInfo["phone"] as? String,
            let email = userInfo["email"] as? String,
            let customerID = userInfo["customerId"] as? Int,
            let address1 = userInfo["address1"] as? String,
            let address2 = userInfo["address2"] as? String,
            let landmark = userInfo["landmark"] as? String,
            let city = userInfo["city"] as? String
            else {
                return
        }
        
        if let strBase64 = userInfo["image"] as? String {
            if let decodedData = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters) {
                profileImage.image = UIImage(data: decodedData)
                profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
                profileImage.clipsToBounds = true
            }
            UserDefaults.standard.set(strBase64, forKey: "image")
        }
        UserDefaults.standard.set(customerID, forKey: "customerId")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(lName, forKey: "lname")
        UserDefaults.standard.set(fName, forKey: "fname")
        UserDefaults.standard.set(mobileNumber, forKey: "mobileNumber")
        
        nameField.text = fName
        mailField.text = email
        phoneField.text = mobileNumber
        addressField.text = "\(address1) \(address2) \(city) \(landmark)"
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 7
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  indexPath.section == 4 {
            // Sample link
            share(message: "HariBol", link: "htttp://google.com")
        }
        
        if indexPath.section == 6 {
            let actionSheetController = UIAlertController(title: "", message: "Are you sure you want to log out of the app?", preferredStyle: .actionSheet)
            
            guard let delegate = UIApplication.shared.delegate as? AppDelegate  else {
                return
            }
            
            let signOutActionButton = UIAlertAction(title: "Sign Out", style: .default) { action in
                UserDefaults.standard.set(nil, forKey: "token")
                UserDefaults.standard.set(false, forKey: "verified")
                flowVar = "normal"
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                delegate.window?.rootViewController = UINavigationController(rootViewController: vc)
                
            }
            actionSheetController.addAction(signOutActionButton)
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in
                actionSheetController.view.tintColor = UIColor.red
            }
            actionSheetController.addAction(cancelActionButton)
            
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }    
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
