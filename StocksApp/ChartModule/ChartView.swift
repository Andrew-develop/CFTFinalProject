//
//  ChartView.swift
//  StocksApp
//
//  Created by Sergio Ramos on 28.12.2021.
//

import UIKit
import Charts

protocol IChartView: UIView {
    func update(closePrices: [ChartDataEntry])
}

final class ChartView: UIView {

    private lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        
        if let font = UIFont(name: "Inter-Semibold", size: 12) {
            chartView.leftAxis.labelFont = font
            chartView.rightAxis.labelFont = font
            chartView.xAxis.labelFont = font
        }
        
        chartView.xAxis.axisMinimum = 1
        chartView.xAxis.granularity = 1
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ChartView: IChartView {
    
    func update(closePrices: [ChartDataEntry]) {
        self.lineChartView.xAxis.axisMaximum = Double(closePrices.count)
        
        let newSet = LineChartDataSet(entries: closePrices, label: "Price change in \(closePrices.count - 1) days")
        newSet.mode = .cubicBezier
        newSet.drawCirclesEnabled = false
        newSet.lineWidth = 3
        newSet.setColor(.link)
        newSet.fill = Fill(color: .link)
        newSet.fillAlpha = 0.5
        newSet.drawFilledEnabled = true
        newSet.drawVerticalHighlightIndicatorEnabled = false
        newSet.drawVerticalHighlightIndicatorEnabled = false
        
        
        let data = LineChartData(dataSet: newSet)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
}

private extension ChartView {
    
    private func configView() {
        self.addSubview(self.lineChartView)
        NSLayoutConstraint.activate([
            self.lineChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.lineChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.lineChartView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.lineChartView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
