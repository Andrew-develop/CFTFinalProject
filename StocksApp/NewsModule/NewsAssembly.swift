//
//  NewsAssembly.swift
//  StocksApp
//
//  Created by Sergio Ramos on 28.12.2021.
//

import Foundation

final class NewsAssembly {
    
    static func build(ticker: String) -> NewsViewController {
        
        let networkService = NetworkService()
        let dialogManager = DialogManager()
        
        let interactor = NewsInteractor(
            dependencies: .init(
                        networkService: networkService,
                        dialogManager: dialogManager
            ), ticker: ticker)
        
        let presenter = NewsPresenter(
            dependencies: .init(
                interactor: interactor
            ))

        let controller = NewsViewController(
            dependencies: .init(
                presenter: presenter
            ))

        dialogManager.setController(controller: controller)
        presenter.setController(controller: controller)
        
        return controller
    }
}
