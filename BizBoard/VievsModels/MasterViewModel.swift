// MasterViewModel.swift
//
//  ProductViewModel.swift
//  test2Json
//
//  Created by Тимур Хазеев on 22.01.2024.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var shortSalesInfo: ShortSalesInfoStatistic?
    @Published var salesByDays: SalesByDays?
    @Published var topRetailers: [TopRetailer] = []
    @Published var selectedPeriod: Period = .day  // Default period
    @Published var selectedChartType: ChartType = .bar // Default chart type

    init() {
        fetchData()
    }

    func fetchData() {
        // Загрузка данных для самых продаваемых продуктов
        if let productUrl = URL(string: "https://admin.n1.devb2border.com/kr/best_selling_products.json") {
            URLSession.shared.dataTask(with: productUrl) { data, _, error in
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode([Product].self, from: data)
                        DispatchQueue.main.async {
                            self.products = decodedData
                        }
                    } catch {
                        print("Error decoding product JSON: \(error)")
                    }
                }
            }.resume()
        }

        // Загрузка данных для краткой информации о продажах
        if let shortSalesInfoUrl = URL(string: "https://admin.n1.devb2border.com/kr/getShortSalesInfoStatistic.json") {
            URLSession.shared.dataTask(with: shortSalesInfoUrl) { data, _, error in
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(ShortSalesInfoStatistic.self, from: data)
                        DispatchQueue.main.async {
                            self.shortSalesInfo = decodedData
                        }
                    } catch {
                        print("Error decoding short sales info JSON: \(error)")
                    }
                }
            }.resume()
        }

        // Загрузка данных для продажи по дням
        if let salesByDaysUrl = URL(string: "https://admin.n1.devb2border.com/kr/sales_by_days.json") {
            URLSession.shared.dataTask(with: salesByDaysUrl) { data, _, error in
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(SalesByDays.self, from: data)
                        DispatchQueue.main.async {
                            self.salesByDays = decodedData
                        }
                    } catch {
                        print("Error decoding sales by days JSON: \(error)")
                    }
                }
            }.resume()
        }

        // Загрузка данных для лучших ретейлеров
        if let topRetailersUrl = URL(string: "https://admin.n1.devb2border.com/kr/top_retailers.json") {
            URLSession.shared.dataTask(with: topRetailersUrl) { data, _, error in
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode([TopRetailer].self, from: data)
                        DispatchQueue.main.async {
                            self.topRetailers = decodedData
                        }
                    } catch {
                        print("Error decoding top retailers JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}
