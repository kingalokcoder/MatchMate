import SwiftUI

struct ProfileCard: Identifiable {
    let profile: Profile
    var status: ProfileStatus
    var offset: CGSize
    
    var id: String { profile.id }
    
    init(profile: Profile) {
        self.profile = profile
        self.status = .all
        self.offset = .zero
    }
}
