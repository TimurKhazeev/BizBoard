import SwiftUI
import Charts

struct SalesByDaysChartView: View {
    @ObservedObject var viewModel: ProductViewModel
    
    @State private var selectedPeriod: Period = .month
    @State private var selectedChartType: ChartType = .bar
    @State private var currentIndex: Int = 0
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    var filteredData: [SalesByDays.MainDiagramInfo] {
        guard let salesData = viewModel.salesByDays?.main_diagram_info else { return [] }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        switch selectedPeriod {
        case .day, .week, .month, .year:
            let chunkSize = selectedPeriod.chunkSize
            let startIndex = currentIndex * chunkSize
            let endIndex = min(startIndex + chunkSize, salesData.count)
            return Array(salesData[startIndex..<endIndex])
        case .custom:
            return salesData.filter {
                guard let dateString = $0.date, let date = dateFormatter.date(from: dateString) else { return false }
                return date >= startDate && date <= endDate
            }
        }
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
            
            if selectedPeriod == .custom {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    .padding()
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    .padding()
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
                    case .custom:
                        maxIndex = 0
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
                .frame(height: 400)
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
        case .custom:
            return 1
        }
    }
}

