//
//  ChartAssembly.swift
//  StocksApp
//
//  Created by Sergio Ramos on 28.12.2021.
//

import Foundation

final class ChartAssembly {
    
    static func build(ticker: String) -> ChartViewController {
        
        let networkService = NetworkService()
        let dialogManager = DialogManager()
        
        let interactor = ChartInteractor(
            dependencies: .init(
                        networkService: networkService,
                        dialogManager: dialogManager
            ), ticker: ticker)
        
        let presenter = ChartPresenter(
            dependencies: .init(
                interactor: interactor
            ))

        let controller = ChartViewController(
            dependencies: .init(
                presenter: presenter
            ))

        dialogManager.setController(controller: controller)
        presenter.setController(controller: controller)
        
        return controller
    }
}
