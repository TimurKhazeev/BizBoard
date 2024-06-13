//
//  RegistrationView.swift
//  SocialRating
//
//  Created by Тимур Хазеев on 11.11.2023.
//
// Страница регистрации

import SwiftUI

struct RegistrationView: View {
  
  @Environment(\.presentationMode) var presentationMode
  @StateObject var viewModel = RegistrationViewModel()
  
  var body: some View {
    
    ScrollView{
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
      
      // Сообщение об ошибки
      VStack {
        if !viewModel.errorMessage.isEmpty {
          Text(viewModel.errorMessage)
            .foregroundColor(.red)
        }
      }
      .padding(.top, 15)
      
      // Блок регестрации
      VStack{
        
        // Подзаголовок
        HStack{
          Text("Registration")
            .font(.system(size: 30))
            .foregroundColor(.midnightBlue)
            .bold()
          Spacer()
        }
        .padding(.top, 25)
        
        // Блок имени
        HStack{
          Text("Full name")
          Spacer()
        }
        .padding(.top, 10)
        
        
        TextField("Enter full name", text: $viewModel.name)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .autocorrectionDisabled(true)
        
        // Блок mail
        HStack{
          Text("Email")
          Spacer()
        }
        .padding(.top, 15)
        
        TextField("Enter Email", text: $viewModel.mail)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .autocorrectionDisabled(true)
        
        // Блок пароля
        HStack{
          Text("Password")
          Spacer()
        }
        .padding(.top, 15)
        
        SecureField("Enter the password", text: $viewModel.password)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        
        // Блок повтора пароля
        HStack{
          Text("Repeat password")
          Spacer()
        }
        .padding(.top, 15)
        
        SecureField("Enter the password", text: $viewModel.passwordRepeat)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        
        // Кнопка регистрации
        Button(action: {
          viewModel.registration()
        }) {
          Text("Registration")
            .font(.system(size: 26))
            .foregroundColor(.white)
            .bold()
        }
        .buttonStyle(SRButtonStyle())
        .padding(.top, 25)
        .padding(.bottom, 50)
        
      }
      .padding()
    }

    
    // Кнопка возврата на страницу входа
    HStack {
      Text("Already have an account?")
        .foregroundColor(.gray)
      
      Button(action: {
        presentationMode.wrappedValue.dismiss()
      }) {
        Text("Login")
          .foregroundColor(.midnightBlue)
          .padding()
      }
    }
    
    
  }
    
}

#Preview {
  RegistrationView()
}
