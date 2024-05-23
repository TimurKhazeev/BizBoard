//
//  TopRetailersChartView.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 23.05.2024.
//

import Foundation
import SwiftUI
import Charts

struct TopRetailersChartView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        VStack {
            Text("Top Retailers")
                .font(.title)
                .padding()
            
            if viewModel.topRetailers.isEmpty {
                Text("Loading...")
            } else {
                Chart {
                    ForEach(viewModel.topRetailers) { retailer in
                        BarMark(
                            x: .value("Retailer", retailer.name),
                            y: .value("Difference", retailer.diff)
                        )
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}
