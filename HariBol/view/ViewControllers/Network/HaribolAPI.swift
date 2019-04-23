//
//  HaribolAPI.swift
//  HariBol
//
//  Created by Narasimha on 06/01/19.
//  Copyright © 2019 haribol. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

typealias ServiceResponse = (NSDictionary?, NSError?) -> Void
typealias serviceResponse = (Data?, NSDictionary?, NSError?) -> Void
typealias FailureReason = (NSError?)-> Void

let haribolURL = "http://13.232.250.182:8443"


class HaribolAPI: NSObject {
    
    func validateMobile(number:String) -> String {
        return "\(haribolURL)/haribol/customer/generate?mobile=\(number)"
    }
    
    func validateOTP() -> String {
        return "\(haribolURL)/haribol/customer/validate"
    }
    
    func postRegistration() -> String {
        return "\(haribolURL)/haribol/customer"
    }
    
    func updateRegistration() -> String {
        return "\(haribolURL)/haribol/customer"
    }
    
    func getCustomerDetails(mobile:String) -> String {
         return "\(haribolURL)/haribol/customer/details?mobile=\(mobile)"
    }
    
    func getBanner() -> String {
        return "\(haribolURL)/haribol/utils/info"
    }
    
    func postFeedback() -> String {
        return "\(haribolURL)/haribol/utils/feedback"
    }
    
    func getProductsList(customerId:Int) -> String {
        return "\(haribolURL)/haribol/product/list/\(customerId)"
    }
    
    func getOrderedList(customerId:Int, date:String) -> String {
        return "\(haribolURL)/haribol/orders?customerId=\(customerId)&date=\(date)"
    }
    
    func postSubscriptionDetails() -> String {
        return "\(haribolURL)/haribol/orders"
    }
    
    func vacationPlan() -> String {
        return "\(haribolURL)/haribol/orders/vacation"
    }
    
    func postTransaction() -> String {
        return "\(haribolURL)/haribol/transactions"
    }
    
    func getTransactions(customerId:String) -> String {
        return "\(haribolURL)/haribol/transactions/list?id=\(customerId)"
    }
    
    //MARK: VALIDATE MOBILE API for session timeout
    func validateMobile(number:String, onCompletion: @escaping ServiceResponse, onFailure: @escaping FailureReason) {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            HaribolAlert().alertMsg(message: "An internet connection is required.\n Please try again after a connection is established.", actionButtonTitle: "OK", title: "HariBol")
            onCompletion(nil, nil)
            return
        }
        let mobileEndPoint = URL(string:validateMobile(number: number))
        
        Alamofire.request(mobileEndPoint!, method:.post,  parameters:nil, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                switch response.result {
                case .success:
                    onCompletion(response.result.value as? NSDictionary, nil)
                case .failure(let error):
                    onFailure(error as NSError)
                }
        }
    }
    
    //MARK: VALIDATE OTP API for session timeout
    func validateOTP(number:Int, onCompletion: @escaping ServiceResponse, onFailure: @escaping FailureReason) {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            HaribolAlert().alertMsg(message: "An internet connection is required.\n Please try again after a connection is \n established.", actionButtonTitle: "OK", title: "HariBol")
            onCompletion(nil, nil)
            return
        }
        guard let otpEndPoint = URL(string:validateOTP()),
            let mobileNumber = UserDefaults.standard.value(forKey: "mobileNumber") as? String
            else {
                onCompletion(nil, nil)
                return
        }
        
        let parameters = ["mobile":Int(mobileNumber)!, "otp":number] as [String : Any]
        
        Alamofire.request(otpEndPoint, method:.post, parameters:parameters, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                switch response.result {
                case .success:
                    onCompletion(response.result.value as? NSDictionary, nil)
                case .failure(let error):
                    onFailure(error as NSError)
                }
        }
    }
    
    //MARK: REGISTRATION  API
    func registration(parameters:[String:Any], onCompletion: @escaping ServiceResponse, onFailure: @escaping FailureReason) {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            HaribolAlert().alertMsg(message: "An internet connection is required.\n Please try again after a connection is \n established.", actionButtonTitle: "OK", title: "HariBol")
            onCompletion(nil, nil)
            return
        }
        guard let registrationEndPoint = URL(string:postRegistration())
            else {
                onCompletion(nil, nil)
                return
        }
 
        
        Alamofire.request(registrationEndPoint, method:.post,  parameters:parameters, encoding: JSONEncoding.default,headers: HaribolAPIUtilities().prepareHeaders())
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                switch response.result {
                case .success:
                    onCompletion(response.result.value as? NSDictionary, nil)
                case .failure(let error):
                    onFailure(error as NSError)
                }
         }
    }
    
    // Retrieve Banners
    func getBanner(onCompletion: @escaping ServiceResponse, onFailure: @escaping FailureReason) {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            HaribolAlert().alertMsg(message: "An internet connection is required.\n Please try again after a connection \n is established.", actionButtonTitle: "OK", title: "HariBol")
            onCompletion(nil, nil)
            return
        }
        guard let customerEndPoint = URL(string:getBanner())
            else {
                onCompletion(nil, nil)
                return
        }
        
        Alamofire.request(customerEndPoint, method:.get, parameters:nil, encoding:JSONEncoding.default, headers: HaribolAPIUtilities().prepareHeaders())
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print(response.response!.statusCode)
                    onCompletion(response.result.value as? NSDictionary, nil)
                case .failure(let error):
                    print(response.response!.statusCode)
                    onFailure(error as NSError)
                }
        }
    }
    
    // Get Customer Details
    func getCustomerDetails(onCompletion: @escaping ServiceResponse, onFailure: @escaping FailureReason) {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            HaribolAlert().alertMsg(message: "An internet connection is required.\n Please try again after a connection is \n established.", actionButtonTitle: "OK", title: "HariBol")
            onCompletion(nil, nil)
            return
        }
        guard
            let mobileNumber = UserDefaults.standard.value(forKey: "mobileNumber") as? String,
            let customerEndPoint = URL(string:getCustomerDetails(mobile:mobileNumber))
            else {
                onCompletion(nil, nil)
                return
        }
       
        Alamofire.request(customerEndPoint, method:.get, parameters:nil, encoding:JSONEncoding.default, headers: HaribolAPIUtilities().prepareHeaders())
            .validate(statusCode: 200..<400)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success:
                    onCompletion(response.result.value as? NSDictionary, nil)
                case .failure(let error):
                    onFailure(error as NSError)
                }
        }
    }
    
    //MARK: Profile Update
    func updateProfile(parameters:[String:Any], onCompletion: @escaping ServiceResponse, onFailure: @escaping FailureReason) -> Void {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            HaribolAlert().alertMsg(message: "An internet connection is required.\n Please try again after a connection is \n established.", actionButtonTitle: "OK", title: "HariBol")
            onCompletion(nil, nil)
            return
        }
        
        guard let updateProfileEndPoint = URL(string:postRegistration())
            else {
                onCompletion(nil, nil)
                return
        }
        
        Alamofire.request(updateProfileEndPoint, method:.put,  parameters:parameters, encoding: JSONEncoding.default, headers: HaribolAPIUtilities().prepareHeaders())
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                switch response.result {
                case .success:
                    onCompletion(response.result.value as? NSDictionary, nil)
                case .failure(let error):
                    print(response.response!.statusCode)
                    onFailure(error as NSError)
                }
        }
    }
    
    //Feedback
    func feedBack(parameters:[String:Any], onCompletion: @escaping ServiceResponse, onFailure: @escaping FailureReason) {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            HaribolAlert().alertMsg(message: "An internet connection is required.\n Please try again after a connection is \n established.", actionButtonTitle: "OK", title: "HariBol")
            onCompletion(nil, nil)
            return
        }
        guard let feedbackEndPoint = URL(string:postFeedback())
        else {
            onCompletion(nil, nil)
            return
        }
       
        Alamofire.request(feedbackEndPoint, method:.post,  parameters:parameters, encoding: JSONEncoding.default, headers: HaribolAPIUtilities().prepareHeaders())
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                switch response.result {
                case .success:
                    onCompletion(response.result.value as? NSDictionary, nil)
                case .failure(let error):
                    onFailure(error as NSError)
                }
        }
    }
    
    
    // Get Customer Details
    func getProductsList(onCompletion: @escaping serviceResponse, onFailure: @escaping FailureReason) {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            HaribolAlert().alertMsg(message: "An internet connection is required.\n Please try again after a connection is \n established.", actionButtonTitle: "OK", title: "HariBol")
            onCompletion(nil, nil, nil)
            return
        }
        guard
            let customerId = UserDefaults.standard.value(forKey: "customerId") as? Int,
            let customerEndPoint = URL(string:getProductsList(customerId: customerId))
            else {
                onCompletion(nil, nil, nil)
                return
        }
      
        Alamofire.request(customerEndPoint, method:.get, parameters:nil, encoding:JSONEncoding.default, headers: HaribolAPIUtilities().prepareHeaders())
            .validate(statusCode: 200..<400)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let _ = response.result.value as? NSDictionary {
                        onCompletion(response.data, response.result.value as? NSDictionary, nil)
                    } else {
                        onCompletion(nil, nil , nil)
                    }
                case .failure(let error):
                    onFailure(error as NSError)
                }
        }
    }
    
    func getOrderedList(date:String, onCompletion: @escaping serviceResponse, onFailure: @escaping FailureReason) {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            HaribolAlert().alertMsg(message: "An internet connection is required.\n Please try again after a connection is \n established.", actionButtonTitle: "OK", title: "HariBol")
            onCompletion(nil, nil, nil)
            return
        }
        guard
            let customerId = UserDefaults.standard.value(forKey: "customerId") as? Int,
            let customerEndPoint = URL(string:getOrderedList(customerId: customerId, date: date))
        else {
            onCompletion(nil, nil, nil)
            return
        }
       
        Alamofire.request(customerEndPoint, method:.get, parameters:nil, encoding:JSONEncoding.default, headers: HaribolAPIUtilities().prepareHeaders())
            .validate(statusCode: 200..<400)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let _ = response.result.value as? NSDictionary {
                        onCompletion(response.data, response.result.value as? NSDictionary, nil)
                    } else {
                        onCompletion(nil, nil , nil)
                    }
                case .failure(let error):
                    onFailure(error as NSError)
                }
        }
    }
    
    //MARK: REGISTRATION  API
    func postSubscriptionDetails(httpMethod:HTTPMethod, parameters:[Parameters], onCompletion: @escaping ServiceResponse, onFailure: @escaping FailureReason) {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            HaribolAlert().alertMsg(message: "An internet connection is required.\n Please try again after a connection is \n established.", actionButtonTitle: "OK", title: "HariBol")
            onCompletion(nil, nil)
            return
        }
        guard let postSubscriptionEndPoint = URL(string:postSubscriptionDetails())
            else {
                onCompletion(nil, nil)
                return
        }
       
        Alamofire.request(postSubscriptionEndPoint, method:httpMethod, encoding: JSONArrayEncoding(array: parameters), headers: HaribolAPIUtilities().prepareHeaders())
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                switch response.result {
                case .success:
                    print(response.response!.statusCode)
                    onCompletion(response.result.value as? NSDictionary, nil)
                case .failure(let error):
                    print(response.response!.statusCode)
                    onFailure(error as NSError)
                }
        }
    }
    
    struct JSONArrayEncoding: ParameterEncoding {
        private let array: [Parameters]
        
        init(array: [Parameters]) {
            self.array = array
        }
        
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            var urlRequest = try urlRequest.asURLRequest()
            
            let data = try JSONSerialization.data(withJSONObject: array, options: [])
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = data
            
            return urlRequest
        }
    }
    
    //MARK: Profile Update
    func vacationPlan(parameters:[String:Any], onCompletion: @escaping ServiceResponse, onFailure: @escaping FailureReason) -> Void {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            HaribolAlert().alertMsg(message: "An internet connection is required.\n Please try again after a connection is \n established.", actionButtonTitle: "OK", title: "HariBol")
            onCompletion(nil, nil)
            return
        }
        
        guard let updateProfileEndPoint = URL(string:vacationPlan())
            else {
                onCompletion(nil, nil)
                return
        }
        
        Alamofire.request(updateProfileEndPoint, method:.put,  parameters:parameters, encoding: JSONEncoding.default, headers: HaribolAPIUtilities().prepareHeaders())
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                switch response.result {
                case .success:
                    onCompletion(response.result.value as? NSDictionary, nil)
                case .failure(let error):
                    onFailure(error as NSError)
                }
        }
    }
    
    //
    // Get Customer Details
    func getTransactionList(onCompletion: @escaping ServiceResponse, onFailure: @escaping FailureReason) {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            HaribolAlert().alertMsg(message: "An internet connection is required.\n Please try again after a connection is \n established.", actionButtonTitle: "OK", title: "HariBol")
            onCompletion(nil, nil)
            return
        }
        guard
            let customerId = UserDefaults.standard.value(forKey: "customerId") as? Int,
            let customerEndPoint = URL(string:getTransactions(customerId:"\(customerId)"))
            else {
                onCompletion(nil, nil)
                return
        }
        
        Alamofire.request(customerEndPoint, method:.get, parameters:nil, encoding:JSONEncoding.default, headers: HaribolAPIUtilities().prepareHeaders())
            .validate(statusCode: 200..<400)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let _ = response.result.value as? NSDictionary {
                        onCompletion(response.result.value as? NSDictionary, nil)
                    } else {
                        onCompletion(nil , nil)
                    }
                case .failure(let error):
                    onFailure(error as NSError)
                }
        }
    }
    
    func postTransaction(parameters:[String:Any], onCompletion: @escaping ServiceResponse, onFailure: @escaping FailureReason) {
        
        guard ReachabilityManager.shared.isConnectedToNetwork() else {
            HaribolAlert().alertMsg(message: "An internet connection is required.\n Please try again after a connection is \n established.", actionButtonTitle: "OK", title: "HariBol")
            onCompletion(nil, nil)
            return
        }
        guard let registrationEndPoint = URL(string:postTransaction())
            else {
                onCompletion(nil, nil)
                return
        }
        
        
        Alamofire.request(registrationEndPoint, method:.post,  parameters:parameters, encoding: JSONEncoding.default,headers: HaribolAPIUtilities().prepareHeaders())
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                switch response.result {
                case .success:
                    onCompletion(response.result.value as? NSDictionary, nil)
                case .failure(let error):
                    onFailure(error as NSError)
                }
        }
    }
}

struct HaribolAPIUtilities {
    
    func prepareHeaders() -> HTTPHeaders? {
        guard
            let accessToken = UserDefaults.standard.value(forKey:"token") as? String else {
                return nil
        }
        
        //prepare Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        return headers
    }
}
