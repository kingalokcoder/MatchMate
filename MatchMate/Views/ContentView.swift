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
                    LoadingView()
                } else if let error = viewModel.error {
                    ErrorView(error: error) {
                        Task {
                            await viewModel.fetchProfiles()
                        }
                    }
                } else {
                    ProfileListView(viewModel: viewModel)
                }
            }
            .navigationTitle(Text("Profile Matches"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        NavigationLink {
                            ProfileHistoryView(viewModel: viewModel)
                        } label: {
                            Image(systemName: "clock.arrow.circlepath")
                        }
                        
                        Button {
                            Task {
                                await viewModel.fetchProfiles()
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.fetchProfiles()
        }
    }
}

#Preview {
    ContentView()
}
