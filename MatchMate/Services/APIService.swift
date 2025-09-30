import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
}

class APIService {
    static let shared = APIService()
    private let baseURL = "https://randomuser.me/api/"
    
    private init() {}
    
    func fetchProfiles(count: Int = 10) async throws -> [Profile] {
        guard let url = URL(string: "\(baseURL)?results=\(count)") else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Simulate processing of random user data into our Profile format
        // In a real app, we would properly decode the actual API response
        let profiles = try (0..<count).map { index in
            Profile(
                id: index,
                name: "Sample Name \(index)",
                age: Int.random(in: 21...60),
                location: "Sample Location",
                imageURL: "https://picsum.photos/200/300"
            )
        }
        
        return profiles
    }
}
