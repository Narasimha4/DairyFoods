
import Foundation
struct Products_Base : Codable {
	let data : [Datavalue]?
	let status : String?

	enum CodingKeys: String, CodingKey {

		case data = "data"
		case status = "status"
	}
 
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		data = try values.decodeIfPresent([Datavalue].self, forKey: .data)
		status = try values.decodeIfPresent(String.self, forKey: .status)
	}
}
