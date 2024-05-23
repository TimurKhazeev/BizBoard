//
//  data.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 23.05.2024.
//

import Foundation

func loadData<T: Codable>(from url: URL, completion: @escaping (T?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        let decodedData = try? JSONDecoder().decode(T.self, from: data)
        completion(decodedData)
    }.resume()
}

// Example usage
let salesByDaysURL = URL(string: "http://localhost:8888/Data/sales_by_days.json")!
let topRetailersURL = URL(string: "http://localhost:8888/Data/top_retailers.json")!
let bestSellingProductsURL = URL(string: "http://localhost:8888/Data/best_selling_products.json")!
let shortSalesInfoStatisticURL = URL(string: "http://localhost:8888/Data/getShortSalesInfoStatistic.json")!

loadData(from: salesByDaysURL) { (data: SalesData?) in
    if let salesData = data {
        print(salesData)
    }
}

loadData(from: topRetailersURL) { (data: [Retailer]?) in
    if let retailers = data {
        print(retailers)
    }
}

loadData(from: bestSellingProductsURL) { (data: [Product]?) in
    if let products = data {
        print(products)
    }
}

loadData(from: shortSalesInfoStatisticURL) { (data: ShortSalesInfo?) in
    if let shortSalesInfo = data {
        print(shortSalesInfo)
    }
}
