import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var profileCards: [ProfileCard] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var matchedProfiles: [StoredProfile] = []
    
    private let storage = ProfileStorageManager.shared
    
    init() {
        Task {
            await loadMatchedProfiles()
            await fetchProfiles()
        }
    }
    
    func fetchProfiles() async {
        isLoading = true
        do {
            let fetchedProfiles = try await APIService.shared.fetchProfiles()
            // Filter out profiles that are already stored
            let newProfiles = fetchedProfiles.filter { profile in
                !storage.isProfileStored(withId: profile.id)
            }
            self.profileCards = newProfiles.map { ProfileCard(profile: $0) }
            self.isLoading = false
        } catch {
            self.error = error
            self.isLoading = false
        }
    }
    
    func updateProfile(_ profileCard: ProfileCard, status: ProfileStatus) async {
        if let index = profileCards.firstIndex(where: { $0.id == profileCard.id }) {
            var updatedCard = profileCards[index]
            updatedCard.status = status
            profileCards[index] = updatedCard
            
            // Store the profile with its status
            storage.saveProfile(profileCard.profile, status: status)
            await loadMatchedProfiles() // Refresh matched profiles
            
            // Remove the card after a delay to show the animation
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            profileCards.remove(at: index)
        }
    }
    
    func acceptProfile(_ profileCard: ProfileCard) {
        Task {
            await updateProfile(profileCard, status: .accepted)
        }
    }
    
    func declineProfile(_ profileCard: ProfileCard) {
        Task {
            await updateProfile(profileCard, status: .declined)
        }
    }
    
    func loadMatchedProfiles() async {
        matchedProfiles = storage.getMatchedProfiles()
    }
    
    // Debug helper
    func getStorageSize() -> String {
        return storage.getStorageFileSize()
    }
    
    // Helper method to get profile count by status
    func getProfileCount(for status: ProfileStatus) -> Int {
        switch status {
        case .all:
            return matchedProfiles.count
        case .accepted:
            return matchedProfiles.filter { $0.status == .accepted }.count
        case .declined:
            return matchedProfiles.filter { $0.status == .declined }.count
        }
    }
}
