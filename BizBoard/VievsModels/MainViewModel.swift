//
//  MainViewModel.swift
//  SocialRating
//
//  Created by Тимур Хазеев on 11.11.2023.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class MainViewModel: ObservableObject {
  @Published var currentUserId: String = ""
  
  private var handler: AuthStateDidChangeListenerHandle?

  init() {
    self.handler = Auth.auth().addStateDidChangeListener {
      [weak self] _, user in
      DispatchQueue.main.async {
        self?.currentUserId = user?.uid ?? ""

      }
    }
  }

  public var isSignedId: Bool {
    return Auth.auth().currentUser != nil
  }

  private func fetchUserRole(uid: String) {
    let db = Firestore.firestore()

    db.collection("users").document(uid).getDocument { document, error in
      if let document = document, document.exists {
          DispatchQueue.main.async {
          }
      }
    }
  }
}


