import SwiftUI
import CoreData

class ProfileViewModel: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
    }
    
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
        saveProfileStatus(profile: profile, status: .accepted)
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles.remove(at: index)
        }
    }
    
    func declineProfile(_ profile: Profile) {
        saveProfileStatus(profile: profile, status: .declined)
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles.remove(at: index)
        }
    }
    
    private func saveProfileStatus(profile: Profile, status: MatchStatus) {
        let profileStatus = ProfileStatus(context: viewContext)
        profileStatus.id = Int64(profile.id)
        profileStatus.name = profile.name
        profileStatus.age = Int16(profile.age)
        profileStatus.location = profile.location
        profileStatus.imageURL = profile.imageURL
        profileStatus.status = status.rawValue
        profileStatus.timestamp = Date()
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving profile status: \(error)")
        }
    }
    
    func loadSavedProfiles() -> [ProfileStatus] {
        let fetchRequest = NSFetchRequest<ProfileStatus>(entityName: "ProfileStatus")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ProfileStatus.timestamp, ascending: false)]
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching saved profiles: \(error)")
            return []
        }
    }
}
