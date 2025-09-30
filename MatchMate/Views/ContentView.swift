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
                        viewModel.fetchProfiles()
                    }
                } else {
                    ProfileListView(viewModel: viewModel)
                }
            }
            .navigationTitle("Profile Matches")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.fetchProfiles()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchProfiles()
        }
    }
}

#Preview {
    ContentView()
}
