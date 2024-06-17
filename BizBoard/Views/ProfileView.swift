//
//  ProfileView.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 23.05.2024.
//

import SwiftUI

struct ProfileView: View {
  @StateObject var viewModel = ProfileViewModel()
  
  var body: some View {
    NavigationView {
      VStack {
        if let user = viewModel.user {
          profile(user: user)
        } else {
          Text("Loading Profile ...")
        }
      }
    }
    .onAppear {
      viewModel.fetchUser()
    }
  }
  
  @ViewBuilder
  func profile(user: User) -> some View {
    // Аватар
    Image(systemName: "person.circle")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundColor(Color.midnightBlue)
      .frame(width: 125, height: 125)
      .padding()
    
    
    // Информация
    VStack(alignment: .leading) {
      HStack {
        Text("Name: ")
          .bold()
        Text(user.name)
      }
      .padding()
      
      HStack {
        Text("Email: ")
          .bold()
        Text(user.mail)
      }
      .padding()
    }
    .padding()
    
    // Выход
    Button(action: {
      viewModel.logOut()
    }) {
      Text("Log Out")
        .font(.system(size: 26))
        .foregroundColor(.white)
        .bold()
    }
    .buttonStyle(SRButtonStyle())
  }
}

#Preview {
    ProfileView()
}
