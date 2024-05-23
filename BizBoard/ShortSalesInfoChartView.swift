//
//  ShortSalesInfoChartView.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 23.05.2024.
//

import Foundation
import SwiftUI
import Charts

struct ShortSalesInfoChartView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        VStack {
            Text("Sales Info")
                .font(.title)
                .padding()
            
            if let shortSalesInfo = viewModel.shortSalesInfo {
                Chart {
                    SectorMark(
                        angle: .value("Total Sales", Double(shortSalesInfo.qty_total_sales)),
                        innerRadius: .ratio(0.5),
                        outerRadius: .ratio(0.8)
                    )
                    .foregroundStyle(by: .value("Category", "Total Sales"))

                    SectorMark(
                        angle: .value("Avg Total Sales Percent", Double(shortSalesInfo.avg_total_sales_percent)),
                        innerRadius: .ratio(0.5),
                        outerRadius: .ratio(0.8)
                    )
                    .foregroundStyle(by: .value("Category", "Avg Total Sales Percent"))

                    SectorMark(
                        angle: .value("Total Sales Percent", Double(shortSalesInfo.total_sales_percent) ?? 0.0),
                        innerRadius: .ratio(0.5),
                        outerRadius: .ratio(0.8)
                    )
                    .foregroundStyle(by: .value("Category", "Total Sales Percent"))
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

