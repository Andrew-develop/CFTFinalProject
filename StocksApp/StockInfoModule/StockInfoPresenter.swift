//
//  StockInfoPresenter.swift
//  StocksApp
//
//  Created by Sergio Ramos on 27.12.2021.
//

import Foundation

protocol IStockInfoPresenter: AnyObject {
    func setController(controller: StockInfoViewController)
    func loadView(stockInfoView: IStockInfoView)
    func onViewReady()
}

final class StockInfoPresenter {
    
    private weak var controller: StockInfoViewController?
    private weak var stockInfoView: IStockInfoView?
    private var interactor: IStockInfoInteractor
    private let router: Router
    
    struct Dependencies {
        let interactor: IStockInfoInteractor
        let router: Router
    }
    
    init(dependencies: Dependencies) {
        self.interactor = dependencies.interactor
        self.router = dependencies.router
    }

}

extension StockInfoPresenter: IStockInfoPresenter {
    
    func loadView(stockInfoView: IStockInfoView) {
        self.stockInfoView = stockInfoView
        self.setHandlers()
    }
    
    func setController(controller: StockInfoViewController) {
        self.controller = controller
    }
    
    func onViewReady() {
        self.interactor.fetchStockInfo()
        self.interactor.fetchStockPrice()
    }
}

private extension StockInfoPresenter {
    
    private func setHandlers() {
        self.stockInfoView?.numberOfActions = {
            Action.allCases.count
        }
        
        self.stockInfoView?.getAction = { index in
            Action.allCases[index]
        }
        
        self.stockInfoView?.onCellSelect = { [weak self] index in
            let action = Action.allCases[index]
            switch action {
            case .chart:
                self?.makeChartModule()
            case .events:
                break
            case.forecasts:
                break
            case .news:
                self?.makeNewsModule()
            case .summary:
                break
            }
            
            self?.router.next()
        }
        
        self.interactor.onStockChanged = { [weak self] in
            guard let crudeInfo = self?.interactor.getStockInfo() else { return }
            let info = StockShortInfo(ticker: crudeInfo.ticker, companyName: crudeInfo.name)
            self?.interactor.fetchLogo(url: crudeInfo.logo)
            DispatchQueue.main.async {
                self?.stockInfoView?.updateStockInfo(info: info)
            }
        }
        
        self.interactor.onPriceChanged = { [weak self] in
            guard let crudePrice = self?.interactor.getStockPrice() else { return }
            let currentPrice = String(crudePrice.c)
            let priceChange = String(crudePrice.d)
            let price = Price(currentPrice: currentPrice, priceChange: priceChange)
            DispatchQueue.main.async {
                self?.stockInfoView?.updatePrice(price: price)
            }
        }
        
        self.interactor.onImageChanged = { [weak self] in
            guard let data = self?.interactor.getLogo() else { return }
            DispatchQueue.main.async {
                self?.stockInfoView?.updateImage(data: data)
            }
        }
    }
    
    private func makeChartModule() {
        let ticker = self.interactor.getTicker()
        let nextVC = ChartAssembly.build(ticker: ticker)
        self.router.setTargetController(controller: nextVC)
    }
    
//    private func makeSummaryModule() {
//        let ticker = self.interactor.getTicker()
//        let nextVC = SummaryAssembly.build(ticker: ticker)
//        self.router.setTargetController(controller: nextVC)
//    }
    
    private func makeNewsModule() {
        let ticker = self.interactor.getTicker()
        let nextVC = NewsAssembly.build(ticker: ticker)
        self.router.setTargetController(controller: nextVC)
    }
}
