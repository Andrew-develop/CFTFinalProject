//
//  StocksListPresenter.swift
//  StocksApp
//
//  Created by Sergio Ramos on 26.12.2021.
//

import Foundation

protocol IStocksListPresenter: AnyObject {
    func setController(controller: StocksListViewController)
    func loadView(stocksListView: IStocksListView)
    func onViewReady()
}

final class StocksListPresenter {
    
    private weak var controller: StocksListViewController?
    private weak var stocksListView: IStocksListView?
    private var interactor: IStocksListInteractor
    private let router: Router
    
    struct Dependencies {
        let interactor: IStocksListInteractor
        let router: Router
    }
    
    init(dependencies: Dependencies) {
        self.interactor = dependencies.interactor
        self.router = dependencies.router
    }

}

extension StocksListPresenter: IStocksListPresenter {
    
    func loadView(stocksListView: IStocksListView) {
        self.stocksListView = stocksListView
        self.setHandlers()
    }
    
    func setController(controller: StocksListViewController) {
        self.controller = controller
    }
    
    func onViewReady() {
        self.interactor.getStocks()
        self.stocksListView?.showIndicator()
    }
}

private extension StocksListPresenter {
    
    private func setHandlers() {
        
        self.stocksListView?.onTouchSearchButton = { [weak self] text in
            self?.interactor.filterStocks(by: text)
            DispatchQueue.main.async {
                self?.stocksListView?.update()
            }
        }
        
        self.stocksListView?.onSearchTextEmpty = { [weak self] in
            self?.interactor.getStocks()
        }
        
        self.stocksListView?.numberOfStocks = { [weak self] in
            self?.interactor.numberOfItems
        }
        
        self.stocksListView?.getStockInfo = { [weak self] index in
            guard let crudeStock = self?.interactor.getStock(index: index) else { return nil }
            let goodStock = StockShortInfo(
                ticker: crudeStock.symbol,
                companyName: crudeStock.welcomeDescription
            )
            return goodStock
        }
        
        self.stocksListView?.onSelectCell = { [weak self] index in
            self?.makeNextModule(index: index)
            self?.router.next()
        }
        
        self.interactor.onDataChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.stocksListView?.update()
            }
        }
        
    }
    
    private func makeNextModule(index: Int) {
        let stock = self.interactor.getStock(index: index)
        let nextVC = StockInfoAssembly.build(ticker: stock.symbol)
        self.router.setTargetController(controller: nextVC)
    }
}
