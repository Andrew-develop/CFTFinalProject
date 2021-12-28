//
//  NewsInteractor.swift
//  StocksApp
//
//  Created by Sergio Ramos on 28.12.2021.
//

import Foundation

protocol INewsInteractor {
    func fetchArticles()
    var onArticlesChanged: (() -> Void)? { get set }
    func getArticle(index: Int) -> Article?
    var numberOfArticles: Int { get }
}

final class NewsInteractor {

    private weak var presenter: IChartPresenter?
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
    
    var onArticlesChanged: (() -> Void)?
    
    private var articles: [Article] = []
    
    var numberOfArticles: Int {
        self.articles.count
    }
}

extension NewsInteractor: INewsInteractor {
    
    func fetchArticles() {
        let boundary: [URLQueryItem] = self.makeTimeBoundary()
        self.networkService.loadData(path: Path.companyNews.rawValue, queryItems: boundary) { [weak self] (result: Result<NewsResponse, Error>) in
            switch result {
            case .success(let success):
                self?.articles = success
                self?.onArticlesChanged?()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.dialogManager.showErrorDialog(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    func getArticle(index: Int) -> Article? {
        self.articles[index]
    }
    
}

private extension NewsInteractor {
    
    private func makeTimeBoundary() -> [URLQueryItem] {
        
        let date = Date()
        let currentDay = date
        let dayWeekAgo = date - 604800
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let symbol = URLQueryItem(name: "symbol", value: ticker)
        let from = URLQueryItem(name: "from", value: formatter.string(from: dayWeekAgo))
        let to = URLQueryItem(name: "to", value: formatter.string(from: currentDay))
        
        return [symbol, from, to]
    }
}
