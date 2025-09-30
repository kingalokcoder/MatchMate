import Foundation

struct Profile: Identifiable, Codable {
    let id: String
    let name: PersonName
    let location: Location
    let email: String
    let dob: DateOfBirth
    let picture: Picture
    let gender: String
    
    var fullName: String {
        "\(name.title) \(name.first) \(name.last)"
    }
    
    var locationString: String {
        "\(location.city), \(location.country)"
    }
    
    var imageURL: String {
        picture.large
    }
    
    var age: Int {
        dob.age
    }
    
    struct PersonName: Codable {
        let title: String
        let first: String
        let last: String
    }
    
    struct Location: Codable {
        let street: Street
        let city: String
        let state: String
        let country: String
        let coordinates: Coordinates
        let timezone: Timezone
        
        struct Street: Codable {
            let number: Int
            let name: String
        }
        
        struct Coordinates: Codable {
            let latitude: String
            let longitude: String
        }
        
        struct Timezone: Codable {
            let offset: String
            let description: String
        }
    }
    
    struct DateOfBirth: Codable {
        let date: String
        let age: Int
    }
    
    struct Picture: Codable {
        let large: String
        let medium: String
        let thumbnail: String
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "login"
        case name
        case location
        case email
        case dob
        case picture
        case gender
    }
    
    private enum LoginKeys: String, CodingKey {
        case uuid
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle both direct UUID and nested login container
        if let loginContainer = try? container.nestedContainer(keyedBy: LoginKeys.self, forKey: .id) {
            id = try loginContainer.decode(String.self, forKey: .uuid)
        } else {
            id = try container.decode(String.self, forKey: .id)
        }
        
        name = try container.decode(PersonName.self, forKey: .name)
        location = try container.decode(Location.self, forKey: .location)
        email = try container.decode(String.self, forKey: .email)
        dob = try container.decode(DateOfBirth.self, forKey: .dob)
        picture = try container.decode(Picture.self, forKey: .picture)
        gender = try container.decode(String.self, forKey: .gender)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(location, forKey: .location)
        try container.encode(email, forKey: .email)
        try container.encode(dob, forKey: .dob)
        try container.encode(picture, forKey: .picture)
        try container.encode(gender, forKey: .gender)
    }
}

// API Response structure
struct APIResponse: Codable {
    let results: [Profile]
    let info: ResponseInfo
    
    struct ResponseInfo: Codable {
        let seed: String
        let results: Int
        let page: Int
        let version: String
    }
}
