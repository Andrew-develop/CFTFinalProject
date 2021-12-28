//
//  StockInfoInteractor.swift
//  StocksApp
//
//  Created by Sergio Ramos on 27.12.2021.
//

import Foundation

protocol IStockInfoInteractor {
    func fetchStockInfo()
    func fetchStockPrice()
    func fetchLogo(url: String)
    func getStockInfo() -> StockInfoResponse?
    func getStockPrice() -> StockPriceResponse?
    func getLogo() -> Data?
    func getTicker() -> String
    var onStockChanged: (() -> Void)? { get set }
    var onPriceChanged: (() -> Void)? { get set }
    var onImageChanged: (() -> Void)? { get set }
}

final class StockInfoInteractor {

    private weak var presenter: IStockInfoPresenter?
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
    
    var onStockChanged: (() -> Void)?
    var onPriceChanged: (() -> Void)?
    var onImageChanged: (() -> Void)?
    
    private var stock: StockInfoResponse?
    private var price: StockPriceResponse?
    private var imageData: Data?
    
}

extension StockInfoInteractor: IStockInfoInteractor {
    
    func fetchStockInfo() {
        let item = URLQueryItem(name: "symbol", value: ticker)
        self.networkService.loadData(path: Path.stockInfo.rawValue, queryItems: [item]) { [weak self] (result: Result<StockInfoResponse, Error>) in
            switch result {
            case .success(let success):
                self?.stock = success
                self?.onStockChanged?()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.dialogManager.showErrorDialog(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    func fetchStockPrice() {
        let item = URLQueryItem(name: "symbol", value: ticker)
        self.networkService.loadData(path: Path.stockPrices.rawValue, queryItems: [item]) { [weak self] (result: Result<StockPriceResponse, Error>) in
            switch result {
            case .success(let success):
                self?.price = success
                self?.onPriceChanged?()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.dialogManager.showErrorDialog(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    func fetchLogo(url: String) {
        self.networkService.loadImage(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.imageData = data
                self?.onImageChanged?()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.dialogManager.showErrorDialog(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    func getStockInfo() -> StockInfoResponse? {
        self.stock
    }
    
    func getStockPrice() -> StockPriceResponse? {
        self.price
    }
    
    func getLogo() -> Data? {
        self.imageData
    }
    
    func getTicker() -> String {
        self.ticker
    }
    
}

private extension StockInfoInteractor {
}
