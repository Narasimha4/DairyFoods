

import Foundation
struct Datavalue : Codable {
	let name : String?
	let products : [Products]?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case products = "products"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		products = try values.decodeIfPresent([Products].self, forKey: .products)
	}

}
