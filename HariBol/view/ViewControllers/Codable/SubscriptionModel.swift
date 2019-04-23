
import Foundation

struct SubscriptionModel : Codable {
    let customerId : Int?
    let dates : [String]?
    let endDate : String?
    let frequency : Int?
    let productId : Int?
    let quantity : Int?
    let startDate : String?
    
    enum CodingKeys: String, CodingKey {
        
        case customerId = "customerId"
        case dates = "dates"
        case endDate = "endDate"
        case frequency = "frequency"
        case productId = "productId"
        case quantity = "quantity"
        case startDate = "startDate"
    }
    
    init(customerId:Int?, dates:[String]?, endDate:String?, frequency:Int?, productId:Int?, quantity:Int?, startDate:String?) {
        self.customerId = customerId
        self.dates = dates
        self.endDate = endDate
        self.frequency = frequency
        self.productId = productId
        self.quantity = quantity
        self.startDate = startDate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customerId = try values.decodeIfPresent(Int.self, forKey: .customerId)
        dates = try values.decodeIfPresent([String].self, forKey: .dates)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        frequency = try values.decodeIfPresent(Int.self, forKey: .frequency)
        productId = try values.decodeIfPresent(Int.self, forKey: .productId)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
    }
}
