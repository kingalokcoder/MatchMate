//
//  ContentView.swift
//  MatchMate
//
//  Created by Alok Ranjan on 29/09/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ProfileViewModel
    
    init(context: NSManagedObjectContext? = nil) {
        let context = context ?? PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: ProfileViewModel(context: context))
    }
    
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
                } else if viewModel.profiles.isEmpty {
                    Text("No more profiles")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.profiles) { profile in
                                ProfileCardView(
                                    profile: profile,
                                    onAccept: { viewModel.acceptProfile(profile) },
                                    onDecline: { viewModel.declineProfile(profile) }
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
