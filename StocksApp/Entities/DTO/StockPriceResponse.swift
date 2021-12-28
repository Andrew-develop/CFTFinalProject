//
//  StockPriceResponse.swift
//  StocksApp
//
//  Created by Sergio Ramos on 27.12.2021.
//

import Foundation

struct StockPriceResponse: Decodable {
    let c: Double
    let d: Double
}
