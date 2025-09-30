//
//  ContentView.swift
//  MatchMate
//
//  Created by Alok Ranjan on 29/09/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    VStack {
                        Text("Error loading profiles")
                            .foregroundColor(.red)
                        Button("Retry") {
                            viewModel.fetchProfiles()
                        }
                    }
                } else if viewModel.profileCards.isEmpty {
                    Text("No more profiles")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.profileCards) { profileCard in
                                ProfileCardView(
                                    profileCard: profileCard,
                                    onAccept: { viewModel.acceptProfile(profileCard) },
                                    onDecline: { viewModel.declineProfile(profileCard) }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Profile Matches")
        }
        .onAppear {
            viewModel.fetchProfiles()
        }
    }
}

#Preview {
    ContentView()
}
