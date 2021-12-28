//
//  ChartViewController.swift
//  StocksApp
//
//  Created by Sergio Ramos on 28.12.2021.
//

import UIKit

final class ChartViewController: UIViewController {

    private var chartPresenter: IChartPresenter
    private var chartView: IChartView
    
    struct Dependencies {
        let presenter: IChartPresenter
    }
    
    init(dependencies: Dependencies) {
        self.chartView = ChartView(frame: UIScreen.main.bounds)
        self.chartPresenter = dependencies.presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.chartPresenter.loadView(chartView: self.chartView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chartPresenter.onViewReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.addSubview(chartView)
        self.navigationItem.title = "Chart"
    }

}
