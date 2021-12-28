//
//  StockInfoAssembly.swift
//  StocksApp
//
//  Created by Sergio Ramos on 27.12.2021.
//

import Foundation

final class StockInfoAssembly {
    
    static func build(ticker: String) -> StockInfoViewController {
        
        let networkService = NetworkService()
        let dialogManager = DialogManager()
        let router = Router()
        
        let interactor = StockInfoInteractor(
            dependencies: .init(
                        networkService: networkService,
                        dialogManager: dialogManager
            ), ticker: ticker)
        
        let presenter = StockInfoPresenter(
            dependencies: .init(
                interactor: interactor,
                router: router
            ))

        let controller = StockInfoViewController(
            dependencies: .init(
                presenter: presenter
            ))

        router.setRootController(controller: controller)
        dialogManager.setController(controller: controller)
        presenter.setController(controller: controller)
        
        return controller
    }
}
