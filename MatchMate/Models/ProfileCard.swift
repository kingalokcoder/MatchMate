import SwiftUI

enum MatchStatus {
    case none
    case accepted
    case declined
}

struct ProfileCard: Identifiable {
    let profile: Profile
    var status: MatchStatus
    var offset: CGSize
    
    var id: String { profile.id }
    
    init(profile: Profile) {
        self.profile = profile
        self.status = .none
        self.offset = .zero
    }
}
