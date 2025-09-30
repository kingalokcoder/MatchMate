import SwiftUI

struct ProfileListView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            if viewModel.profileCards.isEmpty {
                EmptyStateView()
            } else {
                cardStack
            }
        }
    }
    
    private var cardStack: some View {
        ZStack {
            ForEach(viewModel.profileCards.prefix(3).reversed()) { card in
                ProfileCardView(
                    profileCard: card,
                    onAccept: {
                        withAnimation {
                            viewModel.acceptProfile(card)
                        }
                    },
                    onDecline: {
                        withAnimation {
                            viewModel.declineProfile(card)
                        }
                    }
                )
                .offset(y: calculateOffset(for: card))
                .scaleEffect(calculateScale(for: card))
            }
        }
        .padding(.horizontal)
    }
    
    private func calculateOffset(for card: ProfileCard) -> CGFloat {
        guard let index = viewModel.profileCards.firstIndex(where: { $0.id == card.id }) else { return 0 }
        return CGFloat(index) * -10
    }
    
    private func calculateScale(for card: ProfileCard) -> CGFloat {
        guard let index = viewModel.profileCards.firstIndex(where: { $0.id == card.id }) else { return 1 }
        return 1.0 - CGFloat(index) * 0.05
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No More Profiles")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Check back later for new matches!")
                .foregroundColor(.gray)
        }
    }
}
