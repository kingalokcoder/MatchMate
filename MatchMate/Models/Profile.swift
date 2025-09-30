import Foundation

struct Profile: Identifiable, Codable {
    let id: Int
    let name: String
    let age: Int
    let location: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case age
        case location
        case imageURL = "image_url"
    }
}

enum MatchStatus: String, Codable {
    case accepted
    case declined
    case pending
}
