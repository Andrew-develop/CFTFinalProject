//
//  StocksListAssembly.swift
//  StocksApp
//
//  Created by Sergio Ramos on 26.12.2021.
//

import Foundation

final class StocksListAssembly {
    
    static func build() -> StocksListViewController {
        
        let networkService = NetworkService()
        let storageService = StorageService()
        let dialogManager = DialogManager()
        let router = Router()
        
        let interactor = StocksListInteractor(
            dependencies: .init(
                        networkService: networkService,
                        storageService: storageService,
                        dialogManager: dialogManager
            ))
        
        let presenter = StocksListPresenter(
            dependencies: .init(
                interactor: interactor,
                router: router
            ))

        let controller = StocksListViewController(
            dependencies: .init(
                presenter: presenter
            ))

        router.setRootController(controller: controller)
        dialogManager.setController(controller: controller)
        presenter.setController(controller: controller)
        interactor.setPresenter(presenter: presenter)
        
        return controller
    }
}
