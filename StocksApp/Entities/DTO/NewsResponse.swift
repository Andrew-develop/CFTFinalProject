//
//  NewsResponse.swift
//  StocksApp
//
//  Created by Sergio Ramos on 28.12.2021.
//

import Foundation

struct Article: Codable {
    let datetime: Int
    let headline: String
    let id: Int
    let image: String
    let source, summary: String
    let url: String
}

typealias NewsResponse = [Article]
