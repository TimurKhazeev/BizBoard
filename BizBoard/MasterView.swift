//
//  MasterView.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 23.05.2024.
//

import SwiftUI

struct MasterView: View {
  
  private let userId: String
  
  init(userId: String) {
    self.userId = userId
  }
  
  @ObservedObject var viewModel = ProductViewModel()
  
  var body: some View {
      ScrollView {
          VStack {
              SalesByDaysChartView(viewModel: viewModel)
              TopRetailersChartView(viewModel: viewModel)
              ShortSalesInfoChartView(viewModel: viewModel)
          }
      }
  }
}

#Preview {
  MasterView(userId: "")
}
