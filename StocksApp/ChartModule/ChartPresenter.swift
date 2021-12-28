//
//  ChartPresenter.swift
//  StocksApp
//
//  Created by Sergio Ramos on 28.12.2021.
//

import Foundation
import Charts

protocol IChartPresenter: AnyObject {
    func setController(controller: ChartViewController)
    func loadView(chartView: IChartView)
    func onViewReady()
}

final class ChartPresenter {
    
    private weak var controller: ChartViewController?
    private weak var chartView: IChartView?
    private var interactor: IChartInteractor
    
    struct Dependencies {
        let interactor: IChartInteractor
    }
    
    init(dependencies: Dependencies) {
        self.interactor = dependencies.interactor
    }

}

extension ChartPresenter: IChartPresenter {
    
    func loadView(chartView: IChartView) {
        self.chartView = chartView
        self.setHandlers()
    }
    
    func setController(controller: ChartViewController) {
        self.controller = controller
    }
    
    func onViewReady() {
        self.interactor.fetchChartValues()
    }
}

private extension ChartPresenter {
    
    private func setHandlers() {
        self.interactor.onChartValuesChanged = { [weak self] in
            
            guard let crudeValues = self?.interactor.getChartValues() else { return }
            var cleanValues = [ChartDataEntry]()
            
            for i in 0..<crudeValues.c.count {
                let value = ChartDataEntry(x: Double(i + 1), y: crudeValues.c[i])
                cleanValues.append(value)
            }
            DispatchQueue.main.async {
                self?.chartView?.update(closePrices: cleanValues)
            }
        }
    }
}
