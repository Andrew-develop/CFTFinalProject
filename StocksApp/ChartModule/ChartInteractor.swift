//
//  ChartInteractor.swift
//  StocksApp
//
//  Created by Sergio Ramos on 28.12.2021.
//

import Foundation

protocol IChartInteractor {
    func fetchChartValues()
    var onChartValuesChanged: (() -> Void)? { get set }
    func getChartValues() -> ClosePricesResponse?
}

final class ChartInteractor {

    private weak var presenter: IChartPresenter?
    private let networkService: INetworkService
    private let dialogManager: IDialogManager
    
    private let ticker: String
    
    struct Dependencies {
        let networkService: INetworkService
        let dialogManager: IDialogManager
    }
    
    init(dependencies: Dependencies, ticker: String) {
        self.networkService = dependencies.networkService
        self.dialogManager = dependencies.dialogManager
        self.ticker = ticker
    }
    
    var onChartValuesChanged: (() -> Void)?
    
    private var closePrices: ClosePricesResponse?
    
}

extension ChartInteractor: IChartInteractor {
    
    func fetchChartValues() {
        let boundary: [URLQueryItem] = self.makeTimeBoundary()
        self.networkService.loadData(path: Path.chartPrices.rawValue, queryItems: boundary) { [weak self] (result: Result<ClosePricesResponse, Error>) in
            switch result {
            case .success(let success):
                self?.closePrices = success
                self?.onChartValuesChanged?()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.dialogManager.showErrorDialog(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    func getChartValues() -> ClosePricesResponse? {
        self.closePrices
    }
    
}

private extension ChartInteractor {
    
    private func makeTimeBoundary() -> [URLQueryItem] {
        
        let date = Date()
        let currentDay = String(Int(date.timeIntervalSince1970))
        let dayWeekAgo = String(Int((date - 1209600).timeIntervalSince1970))
        
        let symbol = URLQueryItem(name: "symbol", value: ticker)
        let resolution = URLQueryItem(name: "resolution", value: "D")
        let from = URLQueryItem(name: "from", value: dayWeekAgo)
        let to = URLQueryItem(name: "to", value: currentDay)
        
        return [symbol, resolution, from, to]
    }
}

