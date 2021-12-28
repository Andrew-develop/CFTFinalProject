//
//  NewsViewController.swift
//  StocksApp
//
//  Created by Sergio Ramos on 28.12.2021.
//

import UIKit

final class NewsViewController: UIViewController {

    private var newsPresenter: INewsPresenter
    private var newsView: INewsView
    
    struct Dependencies {
        let presenter: INewsPresenter
    }
    
    init(dependencies: Dependencies) {
        self.newsView = NewsView(frame: UIScreen.main.bounds)
        self.newsPresenter = dependencies.presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.newsPresenter.loadView(newsView: self.newsView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newsPresenter.onViewReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.addSubview(newsView)
    }

}
