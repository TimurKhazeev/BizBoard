//
//  SRButton.swift
//  SocialRating
//
//  Created by Тимур Хазеев on 16.11.2023.
//

import SwiftUI

struct SRButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 350, height: 50)
            .background(Color.midnightBlue)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .contentShape(Rectangle())
    }
}

