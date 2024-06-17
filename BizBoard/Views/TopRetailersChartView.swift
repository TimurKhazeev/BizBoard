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
    
    @State private var selectedChartType: ChartType = .pie
    @State private var selectedDataKey: DataKey = .diff // Новое состояние для выбора данных
    
    var filteredTopRetailers: [TopRetailer] {
        // Removed the switch statement related to selectedPeriod
        return Array(viewModel.topRetailers.prefix(15)) // Assuming a fixed period of 15 for this example
    }
    
    var body: some View {
        VStack {
            Text("Top Retailers")
                .font(.title)
                .padding()
            
            HStack {
                Menu {
                    ForEach(DataKey.allCases, id: \.self) { dataKey in
                        Button(action: {
                            selectedDataKey = dataKey
                        }) {
                            Text(dataKey.rawValue)
                        }
                    }
                } label: {
                    Label("Data: \(selectedDataKey.rawValue)", systemImage: "chart.bar.xaxis")
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
                                y: .value("Data", dataValue(for: retailer))
                            )
                        }
                    case .line:
                        ForEach(filteredTopRetailers) { retailer in
                            LineMark(
                                x: .value("Retailer", retailer.name),
                                y: .value("Data", dataValue(for: retailer))
                            )
                        }
                    case .pie:
                        ForEach(filteredTopRetailers) { retailer in
                            SectorMark(
                                angle: .value("Data", dataValue(for: retailer))
                            )
                            .foregroundStyle(by: .value("Retailer", retailer.name))
                        }
                    }
                }
                .frame(height: 400)
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
    
    // Helper function to get the selected data value
    private func dataValue(for retailer: TopRetailer) -> Double {
        switch selectedDataKey {
        case .diff:
            return Double(retailer.diff)
        case .quantity:
            return Double(retailer.quantity) ?? 0
        case .ordersQty:
            return Double(retailer.renderInfo.infoItemOrdersQty)
        case .infoItemSum:
            return parseStringToDouble(retailer.renderInfo.infoItemSum)
        case .infoItemShippingPrice:
            return parseStringToDouble(retailer.renderInfo.infoItemShippingPrice)
        case .infoItemDiscountPrice:
            return parseStringToDouble(retailer.renderInfo.infoItemDiscountPrice)
        }
    }
    
    // Helper function to parse string to double
    private func parseStringToDouble(_ value: String) -> Double {
        let cleanedString = value.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
        return Double(cleanedString) ?? 0
    }
}


