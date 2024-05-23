//
//  SalesByDaysChartView.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 23.05.2024.
//

import Foundation
import SwiftUI
import Charts

struct SalesByDaysChartView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        VStack {
            Text("Sales by Days")
                .font(.title)
                .padding()
            
            if let salesByDays = viewModel.salesByDays {
                Chart {
                    ForEach(salesByDays.main_diagram_info, id: \.name) { info in
                        LineMark(
                            x: .value("Date", info.date ?? ""),
                            y: .value("Sales", info.sales ?? 0)
                        )
                    }
                }
                .padding()
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}
