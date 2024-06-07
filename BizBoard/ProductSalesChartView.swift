import SwiftUI
import Charts

struct ProductSalesChartView: View {
    @ObservedObject var viewModel: ProductViewModel

    @State private var selectedChartType: ChartType = .bar
    @State private var currentIndex: Int = 0
    
    var filteredProducts: [Product] {
        guard !viewModel.products.isEmpty else { return [] }
        let chunkSize = 30 // Defaulting to monthly chunks
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
                    let maxIndex = (viewModel.products.count - 1) / 30 // Assuming monthly chunks
                    if currentIndex < maxIndex {
                        currentIndex += 1
                    }
                }) {
                    Label("Next", systemImage: "chevron.right")
                }
                .padding()
                .disabled(currentIndex >= (viewModel.products.count - 1) / 30)
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

