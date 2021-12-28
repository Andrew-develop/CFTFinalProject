//
//  StockInfoResponse.swift
//  StocksApp
//
//  Created by Sergio Ramos on 26.12.2021.
//

import Foundation

struct StockInfoResponse: Decodable {
    let ipo: String
    let logo: String
    let name: String
    let ticker: String
    let weburl: String
    let finnhubIndustry: String
    let phone: String
}
