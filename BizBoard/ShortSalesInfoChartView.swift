//
//  ShortSalesInfoChartView.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 23.05.2024.
//
import SwiftUI
import Charts

struct ShortSalesInfoChartView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    @State private var selectedPeriod: Period = .month
    @State private var selectedChartType: ChartType = .bar
    
    var body: some View {
        VStack {
            Text("Sales Info")
                .font(.title)
                .padding()
            
            HStack {
                Menu {
                    ForEach(Period.allCases, id: \.self) { period in
                        Button(action: {
                            selectedPeriod = period
                        }) {
                            Text(period.rawValue)
                        }
                    }
                } label: {
                    Label("Period: \(selectedPeriod.rawValue)", systemImage: "calendar")
                        .padding()
                }
                
                Menu {
                    ForEach(ChartType.allCases, id: \.self) { chartType in
                        Button(action: {
                            selectedChartType = chartType
                        }) {
                            Text(chartType.rawValue)
                        }
                    }
                } label: {
                    Label("Chart Type: \(selectedChartType.rawValue)", systemImage: "chart.bar")
                        .padding()
                }
            }
            
          if let shortSalesInfo = viewModel.shortSalesInfo {
            Divider()
            Text("Short Sales Info:")
              .font(.headline)
            
            Text("Total Sales: \(shortSalesInfo.total_sales)")
            Text("Total Sales Percent: \(shortSalesInfo.total_sales_percent)")
            Text("Qty Total Sales: \(shortSalesInfo.qty_total_sales)")
            Text("Qty Total Sales Percent: \(shortSalesInfo.qty_total_sales_percent)")
            Text("Avg Total Sales: \(shortSalesInfo.avg_total_sales)")
            Text("Avg Total Sales Percent: \(shortSalesInfo.avg_total_sales_percent)%")
            Text("Total Sales Class: \(shortSalesInfo.total_sales_class)")
            Text("Qty Total Sales Class: \(shortSalesInfo.qty_total_sales_class)")
            Text("Avg Total Class: \(shortSalesInfo.avg_total_class)")
            Text("Avg Total Percent: \(shortSalesInfo.avg_total_percent)")
        } else {
                Text("Loading...")
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}
