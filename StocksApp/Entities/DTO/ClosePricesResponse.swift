//
//  ClosePrices.swift
//  StocksApp
//
//  Created by Sergio Ramos on 28.12.2021.
//

import Foundation

struct ClosePricesResponse: Decodable {
    let c: [Double]
}
