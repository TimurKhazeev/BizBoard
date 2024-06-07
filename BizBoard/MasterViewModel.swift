//
//  ProductViewModel.swift
//  test2Json
//
//  Created by Тимур Хазеев on 22.01.2024.
//

// ProductViewModel.swift

import Foundation
import Combine

enum Period: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case custom = "Custom"
}

enum ChartType: String, CaseIterable {
    case bar = "Bar"
    case line = "Line"
    case pie = "Pie"
}

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


// best_selling_products
struct Product: Codable {
  let productName: String
  let renderInfo: RenderInfo
  let renderDelta: RenderDelta
  let productQuantity: String
  let diff: Int
  
  enum CodingKeys: String, CodingKey {
    case productName = "product_name"
    case renderInfo = "render_info"
    case renderDelta = "render_delta"
    case productQuantity = "product_quantity"
    case diff
  }
}

struct RenderInfo: Codable {
  let infoItemName: String
  let infoItemQty: String
  let infoItemPrice: String
  let infoItemPrevPrice: String
  let infoItemPrevQty: String
  
  enum CodingKeys: String, CodingKey {
    case infoItemName = "info-item-name"
    case infoItemQty = "info-item-qty"
    case infoItemPrice = "info-item-price"
    case infoItemPrevPrice = "info-item-prev-price"
    case infoItemPrevQty = "info-item-prev-qty"
  }
}

struct RenderDelta: Codable {
  let infoItemPrevPrice: String
  let infoItemPrevQty: String
  
  enum CodingKeys: String, CodingKey {
    case infoItemPrevPrice = "info-item-prev-price"
    case infoItemPrevQty = "info-item-prev-qty"
  }
}

// getShortSalesInfoStatistic
struct ShortSalesInfoStatistic: Codable {
  let total_sales: String
  let total_sales_percent: String
  let qty_total_sales: Int
  let qty_total_sales_percent: String
  let avg_total_sales: String
  let avg_total_sales_percent: Int
  let total_sales_class: String
  let qty_total_sales_class: String
  let avg_total_class: String
  let avg_total_percent: String
}

// sales_by_days
struct SalesByDays: Codable {
    struct MainDiagramInfo: Codable {
        let date: String?
        let name: String
        let sales: Int?
    }

    struct AdditionalInfoItem: Codable {
        let name: String
        let total: CustomDecodableNumber
        let percent: String
    }

    struct AdditionalInfo: Codable {
        let per_day: [AdditionalInfoItem]
        let qtr: [AdditionalInfoItem]
        let year: [AdditionalInfoItem]
    }

    struct CustomDecodableNumber: Codable {
        var value: Double?

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let stringValue = try? container.decode(String.self) {
                value = Double(stringValue)
            } else {
                value = try container.decode(Double.self)
            }
        }
    }

    let main_diagram_info: [MainDiagramInfo]
    let additionalInfo: AdditionalInfo?
    let labels: [String]
    let per_day_sum: Double
    let per_qtr_sum: Int
    let per_year_sum: Int
}

// top_retailers
struct TopRetailer: Codable, Identifiable {
    var name: String
    var quantity: String
    var diff: Int
    var renderInfo: RenderInfo
  

    struct RenderInfo: Codable {
        var infoItemName: String
        var infoItemSum: String
        var infoItemOrdersQty: Int
        var infoItemShippingPrice: String
        var infoItemDiscountPrice: String
        

        enum CodingKeys: String, CodingKey {
            case infoItemName = "info-item-name"
            case infoItemSum = "info-item-sum"
            case infoItemOrdersQty = "info-item-orders-qty"
            case infoItemShippingPrice = "info-item-shipping-price"
            case infoItemDiscountPrice = "info-item-discount-price"
        }
    }

    // Идентификатор для использования в ForEach
    var id: String {
        return name
    }
  enum CodingKeys: String, CodingKey {
      case name
      case quantity
      case diff
      case renderInfo = "render_info"
  }
}
