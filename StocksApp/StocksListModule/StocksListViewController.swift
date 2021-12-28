//
//  StocksListViewController.swift
//  StocksApp
//
//  Created by Sergio Ramos on 26.12.2021.
//

import UIKit

final class StocksListViewController: UIViewController {

    private var stocksListPresenter: IStocksListPresenter
    private var stocksListView: IStocksListView
    
    struct Dependencies {
        let presenter: IStocksListPresenter
    }
    
    init(dependencies: Dependencies) {
        self.stocksListView = StocksListView(frame: UIScreen.main.bounds)
        self.stocksListPresenter = dependencies.presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.stocksListPresenter.loadView(stocksListView: self.stocksListView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stocksListPresenter.onViewReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "Stocks"
        self.view.addSubview(stocksListView)
    }

}
