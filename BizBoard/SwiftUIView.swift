import SwiftUI
import Charts

struct ProductSalesChartView: View {
    @ObservedObject var viewModel: ProductViewModel

    @State private var selectedPeriod: Period = .month
    @State private var selectedChartType: ChartType = .bar
    @State private var currentIndex: Int = 0
    
    var filteredProducts: [Product] {
        guard !viewModel.products.isEmpty else { return [] }
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
        let endIndex = min(startIndex + chunkSize, viewModel.products.count)
        return Array(viewModel.products[startIndex..<endIndex])
    }

    var body: some View {
        VStack {
            Text("Product Sales")
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
                        maxIndex = (viewModel.products.count - 1) / 1
                    case .week:
                        maxIndex = (viewModel.products.count - 1) / 7
                    case .month:
                        maxIndex = (viewModel.products.count - 1) / 30
                    case .year:
                        maxIndex = (viewModel.products.count - 1) / 365
                    }
                    if currentIndex < maxIndex {
                        currentIndex += 1
                    }
                }) {
                    Label("Next", systemImage: "chevron.right")
                }
                .padding()
                .disabled(currentIndex >= (viewModel.products.count - 1) / selectedPeriod.chunkSize)
            }

            if filteredProducts.isEmpty {
                Text("Loading...")
            } else {
                Chart {
                    switch selectedChartType {
                    case .bar:
                        ForEach(filteredProducts, id: \.productName) { product in
                            BarMark(
                                x: .value("Product", product.productName),
                                y: .value("Quantity", Int(product.productQuantity) ?? 0)
                            )
                        }
                    case .line:
                        ForEach(filteredProducts, id: \.productName) { product in
                            LineMark(
                                x: .value("Product", product.productName),
                                y: .value("Quantity", Int(product.productQuantity) ?? 0)
                            )
                        }
                    case .pie:
                        ForEach(filteredProducts, id: \.productName) { product in
                            SectorMark(
                                angle: .value("Quantity", Int(product.productQuantity) ?? 0)
                            )
                            .foregroundStyle(by: .value("Product", product.productName))
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
