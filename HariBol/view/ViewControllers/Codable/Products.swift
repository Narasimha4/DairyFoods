

import Foundation
struct Products : Codable {
	let name : String?
	let code : String?
	let description : String?
	let quantity : Int?
	let basePrice : Int?
	let image : String?
	let cgst : String?
	let igst : String?
	let sgst : String?
	let productId : Int?
	let categoryId : Int?
	let dispensibleProduct : Int?
	let hasDispensibleContainer : Int?
	let subscriptable : Int?
	let forSale : Int?
	let hsn : String?
	let quantityWithUOM : String?
	let regions : [Int]?
	let uom : Int?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case code = "code"
		case description = "description"
		case quantity = "quantity"
		case basePrice = "basePrice"
		case image = "image"
		case cgst = "cgst"
		case igst = "igst"
		case sgst = "sgst"
		case productId = "productId"
		case categoryId = "categoryId"
		case dispensibleProduct = "dispensibleProduct"
		case hasDispensibleContainer = "hasDispensibleContainer"
		case subscriptable = "subscriptable"
		case forSale = "forSale"
		case hsn = "hsn"
		case quantityWithUOM = "quantityWithUOM"
		case regions = "regions"
		case uom = "uom"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		code = try values.decodeIfPresent(String.self, forKey: .code)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
		basePrice = try values.decodeIfPresent(Int.self, forKey: .basePrice)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		cgst = try values.decodeIfPresent(String.self, forKey: .cgst)
		igst = try values.decodeIfPresent(String.self, forKey: .igst)
		sgst = try values.decodeIfPresent(String.self, forKey: .sgst)
		productId = try values.decodeIfPresent(Int.self, forKey: .productId)
		categoryId = try values.decodeIfPresent(Int.self, forKey: .categoryId)
		dispensibleProduct = try values.decodeIfPresent(Int.self, forKey: .dispensibleProduct)
		hasDispensibleContainer = try values.decodeIfPresent(Int.self, forKey: .hasDispensibleContainer)
		subscriptable = try values.decodeIfPresent(Int.self, forKey: .subscriptable)
		forSale = try values.decodeIfPresent(Int.self, forKey: .forSale)
		hsn = try values.decodeIfPresent(String.self, forKey: .hsn)
		quantityWithUOM = try values.decodeIfPresent(String.self, forKey: .quantityWithUOM)
		regions = try values.decodeIfPresent([Int].self, forKey: .regions)
		uom = try values.decodeIfPresent(Int.self, forKey: .uom)
	}
}
