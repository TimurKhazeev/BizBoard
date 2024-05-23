//
//  SalesByDaysChartView.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 23.05.2024.

import SwiftUI
import Charts

struct SalesByDaysChartView: View {
    @ObservedObject var viewModel: ProductViewModel
    
  @State private var selectedPeriod: Period = .month
    @State private var selectedChartType: ChartType = .bar
    @State private var currentIndex: Int = 0
    
    var filteredData: [SalesByDays.MainDiagramInfo] {
        guard let salesData = viewModel.salesByDays?.main_diagram_info else { return [] }
        let chunkSize: Int
        switch selectedPeriod {
        case .day:
            chunkSize = 1
        case .week:
            chunkSize = 7
        case .month:
            chunkSize = 30
        case .year:
            chunkSize = 365
        }
        let startIndex = currentIndex * chunkSize
        let endIndex = min(startIndex + chunkSize, salesData.count)
        return Array(salesData[startIndex..<endIndex])
    }
    
    var body: some View {
        VStack {
            Text("Sales by Days")
                .font(.title)
                .padding()
            
            HStack {
                Menu {
                    ForEach(Period.allCases, id: \.self) { period in
                        Button(action: {
                            selectedPeriod = period
                            currentIndex = 0
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
            
            HStack {
                Button(action: {
                    if currentIndex > 0 {
                        currentIndex -= 1
                    }
                }) {
                    Label("Previous", systemImage: "chevron.left")
                }
                .padding()
                .disabled(currentIndex == 0)
                
                Spacer()
                
                Button(action: {
                    let maxIndex: Int
                    switch selectedPeriod {
                    case .day:
                        maxIndex = (viewModel.salesByDays?.main_diagram_info.count ?? 0) - 1
                    case .week:
                        maxIndex = (viewModel.salesByDays?.main_diagram_info.count ?? 0) / 7
                    case .month:
                        maxIndex = (viewModel.salesByDays?.main_diagram_info.count ?? 0) / 30
                    case .year:
                        maxIndex = (viewModel.salesByDays?.main_diagram_info.count ?? 0) / 365
                    }
                    if currentIndex < maxIndex {
                        currentIndex += 1
                    }
                }) {
                    Label("Next", systemImage: "chevron.right")
                }
                .padding()
                .disabled(currentIndex >= (viewModel.salesByDays?.main_diagram_info.count ?? 0) / selectedPeriod.chunkSize)
            }
            
            if let salesByDays = viewModel.salesByDays {
                Chart {
                    switch selectedChartType {
                    case .bar:
                        ForEach(filteredData, id: \.name) { info in
                            BarMark(
                                x: .value("Date", info.date ?? ""),
                                y: .value("Sales", info.sales ?? 0)
                            )
                        }
                    case .line:
                        ForEach(filteredData, id: \.name) { info in
                            LineMark(
                                x: .value("Date", info.date ?? ""),
                                y: .value("Sales", info.sales ?? 0)
                            )
                        }
                    case .pie:
                        ForEach(filteredData, id: \.name) { info in
                            SectorMark(
                                angle: .value("Sales", info.sales ?? 0)
                            )
                            .foregroundStyle(by: .value("Date", info.date ?? ""))
                        }
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

private extension Period {
    var chunkSize: Int {
        switch self {
        case .day:
            return 1
        case .week:
            return 7
        case .month:
            return 30
        case .year:
            return 365
        }
    }
}
