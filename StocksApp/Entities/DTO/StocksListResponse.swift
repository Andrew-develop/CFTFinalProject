//
//  StocksListResponse.swift
//  StocksApp
//
//  Created by Sergio Ramos on 27.12.2021.
//

import Foundation

typealias StocksList = [Stock]

struct Stock: Decodable {
    let welcomeDescription, displaySymbol, figi: String
    let symbol: String

    enum CodingKeys: String, CodingKey {
        case welcomeDescription = "description"
        case displaySymbol, figi, symbol
    }
}
