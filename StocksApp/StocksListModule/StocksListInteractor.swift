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
    func getStock(index: Int) -> Stock
    var onDataChanged: (() -> Void)? { get set }
    func filterStocks(by text: String)
}

final class StocksListInteractor {

    private weak var presenter: IStocksListPresenter?
    private let networkService: INetworkService
    private let dialogManager: IDialogManager
    
    struct Dependencies {
        let networkService: INetworkService
        let dialogManager: IDialogManager
    }
    
    init(dependencies: Dependencies) {
        self.networkService = dependencies.networkService
        self.dialogManager = dependencies.dialogManager
    }
    
    var onDataChanged: (() -> Void)?
    
    private var constantStocks: [Stock] = []
    private var stocks: [Stock] = []
    
    var numberOfItems: Int {
        self.stocks.count
    }
    
}

extension StocksListInteractor: IStocksListInteractor {
    
    func getStocks() {
        guard constantStocks.isEmpty
        else {
            self.stocks = constantStocks
            self.onDataChanged?()
            return
        }
        let item = URLQueryItem(name: "exchange", value: "US")
        self.networkService.loadData(path: Path.stocksList.rawValue, queryItems: [item]) { [weak self] (result: Result<StocksList, Error>) in
            switch result {
            case .success(let success):
                self?.constantStocks = success
                self?.stocks = success
                self?.onDataChanged?()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.dialogManager.showErrorDialog(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    func getStock(index: Int) -> Stock {
        self.stocks[index]
    }
    
    func filterStocks(by text: String) {
        self.stocks = self.constantStocks.filter {
            self.checkOnCoincidence(text: text, searchLocation: $0.symbol) || self.checkOnCoincidence(text: text, searchLocation: $0.welcomeDescription)
        }
        self.onDataChanged?()
    }
    
    func setPresenter(presenter: IStocksListPresenter) {
        self.presenter = presenter
    }
    
}

private extension StocksListInteractor {
    
    private func checkOnCoincidence(text: String, searchLocation: String) -> Bool {
        let regExp = "\(text.lowercased())"
        let regex = try? NSRegularExpression(pattern: regExp)
        let range = NSRange(location: 0, length: searchLocation.count)
        return regex?.firstMatch(in: searchLocation.lowercased(), options: [], range: range) != nil
    }
}
