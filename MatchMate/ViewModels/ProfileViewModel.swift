import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchProfiles() {
        isLoading = true
        Task {
            do {
                let fetchedProfiles = try await APIService.shared.fetchProfiles()
                DispatchQueue.main.async {
                    self.profiles = fetchedProfiles
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    func acceptProfile(_ profile: Profile) {
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles.remove(at: index)
        }
    }
    
    func declineProfile(_ profile: Profile) {
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles.remove(at: index)
        }
    }
}
