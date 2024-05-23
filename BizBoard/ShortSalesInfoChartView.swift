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
                Chart {
                    switch selectedChartType {
                    case .bar:
                        BarMark(
                            x: .value("Category", "Total Sales"),
                            y: .value("Value", Double(shortSalesInfo.qty_total_sales))
                        )
                        BarMark(
                            x: .value("Category", "Avg Total Sales Percent"),
                            y: .value("Value", Double(shortSalesInfo.avg_total_sales_percent))
                        )
                        BarMark(
                            x: .value("Category", "Total Sales Percent"),
                            y: .value("Value", Double(shortSalesInfo.total_sales_percent) ?? 0.0)
                        )
                    case .line:
                        LineMark(
                            x: .value("Category", "Total Sales"),
                            y: .value("Value", Double(shortSalesInfo.qty_total_sales))
                        )
                        LineMark(
                            x: .value("Category", "Avg Total Sales Percent"),
                            y: .value("Value", Double(shortSalesInfo.avg_total_sales_percent))
                        )
                        LineMark(
                            x: .value("Category", "Total Sales Percent"),
                            y: .value("Value", Double(shortSalesInfo.total_sales_percent) ?? 0.0)
                        )
                    case .pie:
                        SectorMark(
                            angle: .value("Total Sales", Double(shortSalesInfo.qty_total_sales))
                        )
                        .foregroundStyle(by: .value("Category", "Total Sales"))
                        SectorMark(
                            angle: .value("Avg Total Sales Percent", Double(shortSalesInfo.avg_total_sales_percent))
                        )
                        .foregroundStyle(by: .value("Category", "Avg Total Sales Percent"))
                        SectorMark(
                            angle: .value("Total Sales Percent", Double(shortSalesInfo.total_sales_percent) ?? 0.0)
                        )
                        .foregroundStyle(by: .value("Category", "Total Sales Percent"))
                    }
                }
                .frame(height: 400) // Increase the height of the chart
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
