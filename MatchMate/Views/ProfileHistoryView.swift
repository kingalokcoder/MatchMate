import SwiftUI

struct ProfileHistoryView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var selectedFilter: ProfileStatus = .all
    
    var filteredProfiles: [StoredProfile] {
        switch selectedFilter {
        case .all:
            return viewModel.matchedProfiles
        case .accepted:
            return viewModel.matchedProfiles.filter { $0.status == .accepted }
        case .declined:
            return viewModel.matchedProfiles.filter { $0.status == .declined }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter Segment Control
            Picker("Filter", selection: $selectedFilter) {
                Text("All").tag(ProfileStatus.all)
                Text("Accepted").tag(ProfileStatus.accepted)
                Text("Declined").tag(ProfileStatus.declined)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.top)
            
            // Stats View
            HStack(spacing: 20) {
                StatView(count: viewModel.getProfileCount(for: .accepted), 
                        title: "Accepted",
                        color: .green)
                StatView(count: viewModel.getProfileCount(for: .declined),
                        title: "Declined",
                        color: .red)
            }
            .padding(.vertical, 10)
            
            // Profile List
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(filteredProfiles) { profile in
                        ProfileHistoryRow(profile: profile)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical, 8)
            }
            .overlay {
                if filteredProfiles.isEmpty {
                    ContentUnavailableView(
                        "No Profiles",
                        systemImage: selectedFilter == .all ? "person.2.slash" : (selectedFilter == .accepted ? "heart.slash" : "xmark.circle"),
                        description: Text("No \(selectedFilter == .all ? "" : "\(selectedFilter.rawValue) ")profiles found")
                    )
                }
            }
        }
        .navigationTitle("Profile History")
        .background(Color(.systemGroupedBackground))
        .onAppear {
            Task {
                await viewModel.loadMatchedProfiles()
            }
        }
        .refreshable {
            await viewModel.loadMatchedProfiles()
        }
    }
}

// Stats View Component
struct StatView: View {
    let count: Int
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 100)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

struct ProfileHistoryRow: View {
    let profile: StoredProfile
    
    var body: some View {
        HStack(spacing: 15) {
            // Profile Image
            AsyncImage(url: URL(string: profile.profile.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            // Profile Info
            VStack(alignment: .leading, spacing: 4) {
                Text("\(profile.profile.name.first) \(profile.profile.name.last)")
                    .font(.headline)
                
                Text("\(profile.profile.age) years • \(profile.profile.location.city), \(profile.profile.location.country)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Status Icon
            Image(systemName: profile.status == .accepted ? "heart.fill" : "xmark.circle.fill")
                .foregroundColor(profile.status == .accepted ? .green : .red)
                .font(.title2)
                .frame(width: 32)
        }
        .padding(.vertical, 8)
    }
}

// Preview
#Preview {
    NavigationView {
        ProfileHistoryView(viewModel: ProfileViewModel())
    }
}
