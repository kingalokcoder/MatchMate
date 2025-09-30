import SwiftUI

struct ProfileCardView: View {
    @State private var offset = CGSize.zero
    @State private var color = Color.white
    let profileCard: ProfileCard
    let onAccept: () -> Void
    let onDecline: () -> Void
    
    private var statusColor: Color {
        switch profileCard.status {
        case .accepted:
            return .green
        case .declined:
            return .red
        case .none:
            return .white
        }
    }
    
    private var statusOverlay: some View {
        ZStack {
            switch profileCard.status {
            case .accepted:
                Text("ACCEPTED")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green.opacity(0.8))
                    .rotationEffect(.degrees(-30))
            case .declined:
                Text("DECLINED")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .rotationEffect(.degrees(-30))
            case .none:
                EmptyView()
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: profileCard.profile.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(statusOverlay)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(profileCard.profile.fullName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    Text("\(profileCard.profile.age)")
                    Text("•")
                    Text(profileCard.profile.locationString)
                }
                .foregroundColor(.gray)
            }
            
            if profileCard.status == .none {
                HStack(spacing: 20) {
                    Button(action: onDecline) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                    
                    Button(action: onAccept) {
                        Image(systemName: "checkmark")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding()
        .background(statusColor)
        .cornerRadius(16)
        .shadow(radius: 5)
        .offset(x: offset.width, y: 0)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    withAnimation {
                        color = offset.width > 0 ? .green.opacity(0.5) : .red.opacity(0.5)
                    }
                }
                .onEnded { gesture in
                    withAnimation {
                        if abs(offset.width) > 100 {
                            if offset.width > 0 {
                                onAccept()
                            } else {
                                onDecline()
                            }
                        } else {
                            offset = .zero
                            color = .white
                        }
                    }
                }
        )
        .animation(.spring(), value: offset)
    }
}
