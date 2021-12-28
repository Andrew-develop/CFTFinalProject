//
//  StockInfoViewController.swift
//  StocksApp
//
//  Created by Sergio Ramos on 27.12.2021.
//

import UIKit

final class StockInfoViewController: UIViewController {

    private var stockInfoPresenter: IStockInfoPresenter
    private var stockInfoView: IStockInfoView
    
    struct Dependencies {
        let presenter: IStockInfoPresenter
    }
    
    init(dependencies: Dependencies) {
        self.stockInfoView = StockInfoView(frame: UIScreen.main.bounds)
        self.stockInfoPresenter = dependencies.presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.stockInfoPresenter.loadView(stockInfoView: self.stockInfoView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stockInfoPresenter.onViewReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.addSubview(stockInfoView)
    }

}
