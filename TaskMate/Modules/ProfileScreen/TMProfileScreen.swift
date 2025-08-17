//
//  TMProfileScreen.swift
//  TaskMate
//
//  Created by Techetron Ventures Ltd on 8/17/25.
//  Copyright © 2025 Akram Ul Hasan. All rights reserved.
//

import SwiftUI

struct TMProfileScreen: View {
    
    @StateObject private var viewModel: TMProfileViewModel
    
    init(viewModel: TMProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(spacing: 16) {
                        if let profileImage = viewModel.profileImage {
                            AsyncImage(url: profileImage) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 70, height: 70)
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70)
                                        .clipShape(Circle())
                                case .failure:
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 70, height: 70)
                                        .clipShape(Circle())
                                @unknown default:
                                    EmptyView()
                                }
                                
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.name)
                                    .font(.headline)
                                
                                Text(viewModel.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Button("Edit Profile Photo") {
                                    viewModel.updateProfilePhoto()
                                }
                                .font(.caption)
                                .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    Section(header: Text("Preferences")) {
                        Picker("Theme Mode", selection: $viewModel.selectedTheme) {
                            ForEach(TMAppTheme.allCases, id: \.self) { mode in
                                Text(mode.rawValue.capitalized).tag(mode)
                            }
                        }
                        .onChange(of: viewModel.selectedTheme) { newValue in
                            viewModel.changeTheme(newValue)
                        }
                        
                        Stepper("Notification Timing: \(viewModel.notificationTiming) min before",
                                value: $viewModel.notificationTiming,
                                in: 5...60,
                                step: 5,
                                onEditingChanged: { _ in
                            viewModel.updateNotificationTiming(viewModel.notificationTiming)
                        })
                        
                        
                        
                        Picker("Notification Sound", selection: $viewModel.notificationSound) {
                            Text("Default").tag("Default")
                            Text("Silent").tag("Silent")
                            Text("Chime").tag("Chime")
                        }
                        .onChange(of: viewModel.notificationSound) { newValue in
                            viewModel.updateNotificationSound(newValue)
                        }
                    }
                    
                    Section(header: Text("Support")) {
                        Button("About Developer") {
                            // Navigate to About Developer
                        }
                        Button("Contact Support / Feedback") {
                            // Navigate to Support / Feedback
                        }
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            viewModel.logout()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Log Out")
                                Spacer()
                            }
                        }
                    }
                }
                .navigationTitle(TMStrings.profile.title)
            }
        }
    }
}
