
import Foundation
struct ProfileResponse : Codable {
	let address1 : String?
	let address2 : String?
	let category : Int?
	let channelId : Int?
	let city : String?
	let country : String?
	let customerId : Int?
	let delBoyId : Int?
	let email : String?
	let firstName : String?
	let image : String?
	let landmark : String?
	let lastName : String?
	let latitude : Int?
	let longitude : Int?
	let phone : String?
	let pincode : String?
	let state : String?
	let systemAddress : String?

	enum CodingKeys: String, CodingKey {

		case address1 = "address1"
		case address2 = "address2"
		case category = "category"
		case channelId = "channelId"
		case city = "city"
		case country = "country"
		case customerId = "customerId"
		case delBoyId = "delBoyId"
		case email = "email"
		case firstName = "firstName"
		case image = "image"
		case landmark = "landmark"
		case lastName = "lastName"
		case latitude = "latitude"
		case longitude = "longitude"
		case phone = "phone"
		case pincode = "pincode"
		case state = "state"
		case systemAddress = "systemAddress"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		address1 = try values.decodeIfPresent(String.self, forKey: .address1)
		address2 = try values.decodeIfPresent(String.self, forKey: .address2)
		category = try values.decodeIfPresent(Int.self, forKey: .category)
		channelId = try values.decodeIfPresent(Int.self, forKey: .channelId)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		country = try values.decodeIfPresent(String.self, forKey: .country)
		customerId = try values.decodeIfPresent(Int.self, forKey: .customerId)
		delBoyId = try values.decodeIfPresent(Int.self, forKey: .delBoyId)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		landmark = try values.decodeIfPresent(String.self, forKey: .landmark)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		latitude = try values.decodeIfPresent(Int.self, forKey: .latitude)
		longitude = try values.decodeIfPresent(Int.self, forKey: .longitude)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		pincode = try values.decodeIfPresent(String.self, forKey: .pincode)
		state = try values.decodeIfPresent(String.self, forKey: .state)
		systemAddress = try values.decodeIfPresent(String.self, forKey: .systemAddress)
	}
}
