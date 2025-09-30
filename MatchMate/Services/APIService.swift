import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case serverError(Int)
}

class APIService {
    static let shared = APIService()
    private let baseURL = "https://randomuser.me/api/"
    
    private init() {}
    
    func fetchProfiles(count: Int = 10) async throws -> [Profile] {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "results", value: String(count))
        ]
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(NSError(domain: "", code: -1))
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(APIResponse.self, from: data)
            return apiResponse.results
        } catch {
            print("Decoding error: \(error)")
            throw APIError.decodingError
        }
    }
}
