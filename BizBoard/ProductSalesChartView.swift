import SwiftUI
import Charts

struct ProductSalesChartView: View {
    @ObservedObject var viewModel: ProductViewModel

    @State private var selectedChartType: ChartType = .bar
    @State private var currentIndex: Int = 0
    @State private var selectedProduct: Product? = nil
    @State private var showDetailSheet: Bool = false

    var filteredProducts: [Product] {
        guard !viewModel.products.isEmpty else { return [] }
        let chunkSize = 30
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
                ZStack {
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

                    ForEach(filteredProducts.indices, id: \.self) { index in
                        let product = filteredProducts[index]
                        let xPosition: CGFloat = CGFloat(index) * (UIScreen.main.bounds.width / CGFloat(filteredProducts.count))

                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            .frame(width: UIScreen.main.bounds.width / CGFloat(filteredProducts.count))
                            .offset(x: xPosition - UIScreen.main.bounds.width / 2 + (UIScreen.main.bounds.width / CGFloat(filteredProducts.count)) / 2)
                            .onTapGesture {
                                selectedProduct = product
                                showDetailSheet = true
                            }
                    }
                }
            }
        }
        .sheet(isPresented: $showDetailSheet) {
            if let selectedProduct = selectedProduct {
                ProductDetailView(product: selectedProduct)
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        List {
            Section(header: Text("Product Details").font(.title)) {
                Text("Name: \(product.productName)")
                Text("Quantity: \(product.productQuantity)")
                Text("Price: \(product.renderInfo.infoItemPrice)")
            }

            Section(header: Text("Render Info")) {
                Text("Item Name: \(product.renderInfo.infoItemName)")
                Text("Item Qty: \(product.renderInfo.infoItemQty)")
                Text("Item Prev Price: \(product.renderInfo.infoItemPrevPrice)")
                Text("Item Prev Qty: \(product.renderInfo.infoItemPrevQty)")
            }

            Section(header: Text("Render Delta")) {
                Text("Delta Prev Price: \(product.renderDelta.infoItemPrevPrice)")
                Text("Delta Prev Qty: \(product.renderDelta.infoItemPrevQty)")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .padding()
    }
}


