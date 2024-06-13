//
//  InputView.swift
//  SocialRating
//
//  Created by Тимур Хазеев on 11.11.2023.
//
// Страница входа

import SwiftUI

struct InputView: View {
  
  @StateObject var viewModel = InputViewModel()
  
  var body: some View {
    
    NavigationView {
      VStack {
        
        // Заголовок
        HStack {
          Image("logoBlue")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 75, height: 75)
          
          Text("BizBoard")
            .font(.system(size: 40))
            .foregroundColor(.midnightBlue)
            .bold()
        }
        .padding(.top, 15)
        
        // Форма входа
        VStack {
          
          // Подзаголовок
          HStack{
            Text("Login")
              .font(.system(size: 30))
              .foregroundColor(.midnightBlue)
              .bold()
            Spacer()
          }
          .padding(.top, 50)
          
          // Сообщение об ошибки
          if !viewModel.errorMessage.isEmpty {
            Text(viewModel.errorMessage)
              .foregroundColor(.red)
          }
          
          // Поле Email
          VStack {
            HStack{
              Text("Email")
              Spacer()
            }
            .padding(.top, 5)
            
            TextField("Enter the Email", text: $viewModel.mail)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .autocorrectionDisabled(true)
            
            // Поле пароль
            HStack{
              Text("Password")
              Spacer()
            }
            .padding(.top, 5)
            
            SecureField("Enter the password", text: $viewModel.password)
              .textFieldStyle(RoundedBorderTextFieldStyle())
            
          }
        }
        .padding()
        
        // Кнопка для входа
        VStack {
          Button(action: {
            viewModel.login()
          }) {
            Text("Login")
              .font(.system(size: 26))
              .foregroundColor(.white)
              .bold()
          }
          .buttonStyle(SRButtonStyle())
          
          Spacer()
        }
        .padding()
        
        
        // Переход на экран создания аккаунта
        VStack {
          HStack {
            Text("There is no account?")
              .foregroundColor(.gray)
            
            NavigationLink("Create", destination: RegistrationView().navigationBarBackButtonHidden(true))
              .foregroundColor(.midnightBlue)
          }
        }
        .padding(.bottom, 75)
        
      }
      .padding(.horizontal, 10)
    }
    
  }
}

#Preview {
  InputView()
}
