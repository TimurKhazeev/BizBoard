//
//  ContentView.swift
//  SocialRating
//
//  Created by Тимур Хазеев on 11.11.2023.
//

import SwiftUI

struct MainView: View {
  
  @StateObject var viewModel = MainViewModel()
  
    var body: some View {
    
      if viewModel.isSignedId, !viewModel.currentUserId.isEmpty {
        accountView
      } else {
        InputView()
      }
    }
  
  @ViewBuilder
  var accountView: some View {
    TabView {
      MasterView(userId: viewModel.currentUserId)
        .tabItem {
          Label("Home", systemImage: "house")
        }
      
      ProfileView()
        .tabItem {
          Label("Profile", systemImage: "person.circle")
        }
    }
  }
}

#Preview {
  MainView()
}
