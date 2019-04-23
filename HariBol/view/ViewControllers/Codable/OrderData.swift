

import Foundation
struct OrderData : Codable {
	let customerId : Int?
	let productId : Int?
	let productName : String?
    let productImage : String?
	let basePrice : Int?
	var orderQuantity : Int?
	let modifiedQuantity : String?
	let uom : Int?
	let cgst : String?
	let sgst : String?
	let igst : String?
	let orderValue : Int?
	let orderDate : Int?
	let orderStatus : Int?
	let deliverQuantity : String?
	let deliverDate : String?
	let deliveredBy : String?
	let deliveryAddress : String?
	let orderId : Int?
	let quantityWithUOM : String?

	enum CodingKeys: String, CodingKey {

		case customerId = "customerId"
		case productId = "productId"
		case productName = "productName"
		case basePrice = "basePrice"
		case orderQuantity = "orderQuantity"
		case modifiedQuantity = "modifiedQuantity"
		case uom = "uom"
		case cgst = "cgst"
		case sgst = "sgst"
		case igst = "igst"
		case orderValue = "orderValue"
		case orderDate = "orderDate"
		case orderStatus = "orderStatus"
		case deliverQuantity = "deliverQuantity"
		case deliverDate = "deliverDate"
		case deliveredBy = "deliveredBy"
		case deliveryAddress = "deliveryAddress"
		case orderId = "orderId"
		case quantityWithUOM = "quantityWithUOM"
        case productImage = "productImage"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		customerId = try values.decodeIfPresent(Int.self, forKey: .customerId)
		productId = try values.decodeIfPresent(Int.self, forKey: .productId)
		productName = try values.decodeIfPresent(String.self, forKey: .productName)
        productImage = try values.decodeIfPresent(String.self, forKey: .productImage)
		basePrice = try values.decodeIfPresent(Int.self, forKey: .basePrice)
		orderQuantity = try values.decodeIfPresent(Int.self, forKey: .orderQuantity)
		modifiedQuantity = try values.decodeIfPresent(String.self, forKey: .modifiedQuantity)
		uom = try values.decodeIfPresent(Int.self, forKey: .uom)
		cgst = try values.decodeIfPresent(String.self, forKey: .cgst)
		sgst = try values.decodeIfPresent(String.self, forKey: .sgst)
		igst = try values.decodeIfPresent(String.self, forKey: .igst)
		orderValue = try values.decodeIfPresent(Int.self, forKey: .orderValue)
		orderDate = try values.decodeIfPresent(Int.self, forKey: .orderDate)
		orderStatus = try values.decodeIfPresent(Int.self, forKey: .orderStatus)
		deliverQuantity = try values.decodeIfPresent(String.self, forKey: .deliverQuantity)
		deliverDate = try values.decodeIfPresent(String.self, forKey: .deliverDate)
		deliveredBy = try values.decodeIfPresent(String.self, forKey: .deliveredBy)
		deliveryAddress = try values.decodeIfPresent(String.self, forKey: .deliveryAddress)
		orderId = try values.decodeIfPresent(Int.self, forKey: .orderId)
		quantityWithUOM = try values.decodeIfPresent(String.self, forKey: .quantityWithUOM)
	}
}
