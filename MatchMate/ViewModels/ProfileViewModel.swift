import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profileCards: [ProfileCard] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func fetchProfiles() {
        isLoading = true
        Task {
            do {
                let fetchedProfiles = try await APIService.shared.fetchProfiles()
                DispatchQueue.main.async {
                    self.profileCards = fetchedProfiles.map { ProfileCard(profile: $0) }
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
    
    func updateProfile(_ profileCard: ProfileCard, status: MatchStatus) {
        if let index = profileCards.firstIndex(where: { $0.id == profileCard.id }) {
            var updatedCard = profileCards[index]
            updatedCard.status = status
            profileCards[index] = updatedCard
            
            // Remove the card after a delay to show the animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.profileCards.remove(at: index)
            }
        }
    }
    
    func acceptProfile(_ profileCard: ProfileCard) {
        updateProfile(profileCard, status: .accepted)
    }
    
    func declineProfile(_ profileCard: ProfileCard) {
        updateProfile(profileCard, status: .declined)
    }
}
