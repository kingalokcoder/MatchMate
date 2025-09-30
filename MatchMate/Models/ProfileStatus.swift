import Foundation

enum ProfileStatus: String, Codable, CaseIterable {
    case accepted
    case declined
    case all // Used for filtering purposes
}
