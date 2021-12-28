//
//  Action.swift
//  StocksApp
//
//  Created by Sergio Ramos on 27.12.2021.
//

import Foundation

enum Action: CaseIterable, CustomStringConvertible {
    
    var description: String {
        switch self {
        case .chart:
            return "Chart"
        case .news:
            return "News"
        case .summary:
            return "Summary"
        case .forecasts:
            return "Forecast"
        case .events:
            return "Events"
        }
    }
    
    case chart
    case summary
    case news
    case forecasts
    case events
}
