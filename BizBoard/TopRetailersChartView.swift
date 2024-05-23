//
//  TopRetailersChartView.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 23.05.2024.
//
import SwiftUI
import Charts

struct TopRetailersChartView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    @State private var selectedPeriod: Period = .month
  @State private var selectedChartType: ChartType = .pie
    
    var filteredTopRetailers: [TopRetailer] {
        switch selectedPeriod {
        case .day:
            return Array(viewModel.topRetailers.prefix(5)) // Пример фильтрации для дневного периода
        case .week:
            return Array(viewModel.topRetailers.prefix(10)) // Пример фильтрации для недельного периода
        case .month:
            return Array(viewModel.topRetailers.prefix(15)) // Пример фильтрации для месячного периода
        case .year:
            return viewModel.topRetailers // Пример фильтрации для годового периода
        }
    }
    
    var body: some View {
        VStack {
            Text("Top Retailers")
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
            
            if filteredTopRetailers.isEmpty {
                Text("Loading...")
            } else {
                Chart {
                    switch selectedChartType {
                    case .bar:
                        ForEach(filteredTopRetailers) { retailer in
                            BarMark(
                                x: .value("Retailer", retailer.name),
                                y: .value("Difference", retailer.diff)
                            )
                        }
                    case .line:
                        ForEach(filteredTopRetailers) { retailer in
                            LineMark(
                                x: .value("Retailer", retailer.name),
                                y: .value("Difference", retailer.diff)
                            )
                        }
                    case .pie:
                        ForEach(filteredTopRetailers) { retailer in
                            SectorMark(
                                angle: .value("Difference", retailer.diff)
                            )
                            .foregroundStyle(by: .value("Retailer", retailer.name))
                        }
                    }
                }
                .frame(height: 400) // Increase the height of the chart
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}
