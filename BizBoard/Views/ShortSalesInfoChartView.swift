//
//  ShortSalesInfoChartView.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 23.05.2024.
//
import SwiftUI

struct ShortSalesInfoChartView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    var body: some View {
        VStack {
            Text("Short Sales Info")
                .font(.title)
                .padding()
            
            if let shortSalesInfo = viewModel.shortSalesInfo {
                Divider()
                Group {
                    InfoRow(title: "Total Sales", value: "\(shortSalesInfo.total_sales)")
                    InfoRow(title: "Total Sales Percent", value: "\(shortSalesInfo.total_sales_percent)")
                    InfoRow(title: "Qty Total Sales", value: "\(shortSalesInfo.qty_total_sales)")
                    InfoRow(title: "Qty Total Sales Percent", value: "\(shortSalesInfo.qty_total_sales_percent)")
                    InfoRow(title: "Avg Total Sales", value: "\(shortSalesInfo.avg_total_sales)")
                    InfoRow(title: "Avg Total Sales Percent", value: "\(shortSalesInfo.avg_total_sales_percent)%")
                    InfoRow(title: "Total Sales Class", value: "\(shortSalesInfo.total_sales_class)")
                    InfoRow(title: "Qty Total Sales Class", value: "\(shortSalesInfo.qty_total_sales_class)")
                    InfoRow(title: "Avg Total Class", value: "\(shortSalesInfo.avg_total_class)")
                    InfoRow(title: "Avg Total Percent", value: "\(shortSalesInfo.avg_total_percent)")
                }
                .padding(.horizontal)
            } else {
                Text("Loading...")
                    .padding()
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}

struct InfoRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
        }
        .padding(.vertical, 4)
    }
}
