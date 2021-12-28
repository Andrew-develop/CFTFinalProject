//
//  NewPresenter.swift
//  StocksApp
//
//  Created by Sergio Ramos on 28.12.2021.
//

import Foundation

protocol INewsPresenter: AnyObject {
    func setController(controller: NewsViewController)
    func loadView(newsView: INewsView)
    func onViewReady()
}

final class NewsPresenter {
    
    private weak var controller: NewsViewController?
    private weak var newsView: INewsView?
    private var interactor: INewsInteractor
    
    struct Dependencies {
        let interactor: INewsInteractor
    }
    
    init(dependencies: Dependencies) {
        self.interactor = dependencies.interactor
    }

}

extension NewsPresenter: INewsPresenter {
    
    func loadView(newsView: INewsView) {
        self.newsView = newsView
        self.setHandlers()
    }
    
    func setController(controller: NewsViewController) {
        self.controller = controller
    }
    
    func onViewReady() {
        self.interactor.fetchArticles()
    }
}

private extension NewsPresenter {
    
    private func setHandlers() {
        
        self.interactor.onArticlesChanged = { [weak self] in
            self?.newsView?.update()
        }
        
        self.newsView?.numberOfArticles = { [weak self] in
            self?.interactor.numberOfArticles
        }
        
        self.newsView?.getArticle = { [weak self] index in
            self?.interactor.getArticle(index: index)
        }
    }
}
