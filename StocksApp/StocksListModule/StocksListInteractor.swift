//
//  StocksListModel.swift
//  StocksApp
//
//  Created by Sergio Ramos on 26.12.2021.
//

import Foundation

protocol IStocksListInteractor {
    func getStocks()
    var numberOfItems: Int { get }
    func getStockInfo(index: Int) -> StockInfoResponse
    var onDataChanged: (() -> Void)? { get set }
    func filterStocks(by text: String)
    var onLoadImage: ((Data) -> Void)? { get set }
    func getLogo(url: String)
}

final class StocksListInteractor {

    private weak var presenter: IStocksListPresenter?
    private let networkService: INetworkService
    private let storageService: IStorageService
    private let dialogManager: IDialogManager
    
    struct Dependencies {
        let networkService: INetworkService
        let storageService: IStorageService
        let dialogManager: IDialogManager
    }
    
    init(dependencies: Dependencies) {
        self.networkService = dependencies.networkService
        self.storageService = dependencies.storageService
        self.dialogManager = dependencies.dialogManager
    }
    
    var onDataChanged: (() -> Void)?
    var onLoadImage: ((Data) -> Void)?
    
    private var constantStocks: [StockInfoResponse] = []
    private var stocks: [StockInfoResponse] = []
    
    var numberOfItems: Int {
        self.stocks.count
    }
    
}

extension StocksListInteractor: IStocksListInteractor {
    
    func getLogo(url: String) {
        self.networkService.loadImage(url: url, completion: { [weak self] result in
            switch result {
            case .success(let data):
                self?.onLoadImage?(data)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.dialogManager.showErrorDialog(title: "Ошибка", message: error.localizedDescription)
                }
            }
        })
    }
    
    func getStocks() {
        let tickers = self.getTickers()
        tickers.forEach { ticker in
            let item = URLQueryItem(name: "symbol", value: ticker)
            self.networkService.loadData(path: Path.stockInfo.rawValue, queryItems: [item]) { [weak self] (result: Result<StockInfoResponse, Error>) in
                switch result {
                case .success(let success):
                    self?.stocks.append(success)
                    self?.onDataChanged?()
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.dialogManager.showErrorDialog(title: "Ошибка", message: error.localizedDescription)
                    }
                }
            }
        }
        self.onDataChanged?()
    }
    
    func getStockInfo(index: Int) -> StockInfoResponse {
        self.stocks[index]
    }
    
    func filterStocks(by text: String) {
        self.stocks = self.constantStocks.filter {
            self.checkOnCoincidence(text: text, searchLocation: $0.name) || self.checkOnCoincidence(text: text, searchLocation: $0.ticker)
        }
        self.onDataChanged?()
    }
    
    func setPresenter(presenter: IStocksListPresenter) {
        self.presenter = presenter
    }
    
}

private extension StocksListInteractor {
    
    private func getTickers() -> [String] {
        ["AAPL","GOOGL","AMZN","BAC","MSFT","TSLA","MA","BA","CCE","DELL"]
    }
    
    private func checkOnCoincidence(text: String, searchLocation: String) -> Bool {
        let regExp = "*\(text)*"
        let regex = try? NSRegularExpression(pattern: regExp)
        let range = NSRange(location: 0, length: searchLocation.count)
        return regex?.firstMatch(in: searchLocation, options: [], range: range) != nil
    }
}
