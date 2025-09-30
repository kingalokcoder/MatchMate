import Foundation

class ProfileStorageManager {
    static let shared = ProfileStorageManager()
    
    private let fileManager = FileManager.default
    private var storageURL: URL
    
    private init() {
        // Get the documents directory
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        storageURL = documentsPath.appendingPathComponent("profiles.json")
        
        // Create the file if it doesn't exist
        if !fileManager.fileExists(atPath: storageURL.path) {
            createEmptyStorage()
        }
    }
    
    private func createEmptyStorage() {
        do {
            let emptyArray: [StoredProfile] = []
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(emptyArray)
            try data.write(to: storageURL, options: .atomic)
        } catch {
            // Handle error silently
        }
    }
    
    // MARK: - Save Profiles
    
    func saveProfile(_ profile: Profile, status: ProfileStatus) {
        do {
            var profiles = getAllProfiles()
            
            let storedProfile = StoredProfile(
                id: profile.id,
                profile: profile,
                status: status,
                timestamp: Date()
            )
            
            // Remove if exists (to update)
            profiles.removeAll { $0.id == profile.id }
            profiles.append(storedProfile)
            
            // Use JSONEncoder with proper configuration
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            encoder.dateEncodingStrategy = .iso8601
            
            let data = try encoder.encode(profiles)
            try data.write(to: storageURL, options: .atomic)
        } catch {
            // Handle error silently
        }
    }
    
    // MARK: - Load Profiles
    
    func getAllProfiles() -> [StoredProfile] {
        do {
            let data = try Data(contentsOf: storageURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([StoredProfile].self, from: data)
        } catch {
            return []
        }
    }
    
    func getMatchedProfiles() -> [StoredProfile] {
        return getAllProfiles()
            .sorted { $0.timestamp > $1.timestamp }
    }
    
    func getUnmatchedProfiles() -> [Profile] {
        let storedIds = Set(getAllProfiles().map { $0.id })
        // In a real app, you'd fetch this from your backend
        // For now, we'll return an empty array as these would be new profiles
        return []
    }
    
    func isProfileStored(withId id: String) -> Bool {
        return getAllProfiles().contains { $0.id == id }
    }
    
    // MARK: - Private Helpers
    
    private func saveProfiles(_ profiles: [StoredProfile]) {
        do {
            let data = try JSONEncoder().encode(profiles)
            try data.write(to: storageURL, options: .atomicWrite)
        } catch {
            // Handle error silently
        }
    }
    
    // MARK: - Debug Helpers
    
    func clearAllProfiles() {
        saveProfiles([])
    }
    
    func getStorageFileSize() -> String {
        do {
            let attributes = try fileManager.attributesOfItem(atPath: storageURL.path)
            let sizeInBytes = attributes[.size] as? Int64 ?? 0
            return ByteCountFormatter.string(fromByteCount: sizeInBytes, countStyle: .file)
        } catch {
            return "Unknown"
        }
    }
}
