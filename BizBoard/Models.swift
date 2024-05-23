//
//  Data.swift
//  BizBoard
//
//  Created by Тимур Хазеев on 23.05.2024.
//

import Foundation

// Model for sales_by_days.json
struct SalesByDay: Codable {
    let date: String
    let name: String
    let sales: Int
}

struct SalesData: Codable {
    let mainDiagramInfo: [SalesByDay]
}

// Model for top_retailers.json
struct Retailer: Codable {
    let name: String
    let quantity: Int
    let diff: Int
    let renderInfo: RenderInfo
}

struct RenderInfo: Codable {
    let infoItemName: String
    let infoItemSum: String
    let infoItemOrdersQty: Int
    let infoItemShippingPrice: String
    let infoItemDiscountPrice: String
}

// Model for best_selling_products.json
struct Product: Codable {
    let productName: String
    let renderInfo: ProductRenderInfo
    let productQuantity: Int
    let diff: Int
}

struct ProductRenderInfo: Codable {
    let infoItemName: String
    let infoItemQty: String
    let infoItemPrice: String
    let infoItemPrevPrice: String
    let infoItemPrevQty: String
}

// Model for getShortSalesInfoStatistic.json
struct ShortSalesInfo: Codable {
    let totalSales: String
    let totalSalesPercent: String
    let qtyTotalSales: Int
    let qtyTotalSalesPercent: String
    let avgTotalSales: String
    let avgTotalSalesPercent: String
    let totalSalesClass: String
    let qtyTotalSalesClass: String
    let avgTotalClass: String
    let avgTotalPercent: String
}


