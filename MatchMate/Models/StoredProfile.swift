import Foundation

struct StoredProfile: Codable, Identifiable {
    let id: String
    let profile: Profile
    let status: ProfileStatus
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case profile
        case status
        case timestamp
    }
    
    init(id: String, profile: Profile, status: ProfileStatus, timestamp: Date) {
        self.id = id
        self.profile = profile
        self.status = status
        self.timestamp = timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        profile = try container.decode(Profile.self, forKey: .profile)
        status = try container.decode(ProfileStatus.self, forKey: .status)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(profile, forKey: .profile)
        try container.encode(status, forKey: .status)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
