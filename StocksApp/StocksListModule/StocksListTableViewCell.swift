//
//  StocksListTableViewCell.swift
//  StocksApp
//
//  Created by Sergio Ramos on 26.12.2021.
//

import UIKit

protocol IStocksListTableViewCell {
    func config(stockInfo: StockShortInfo, number: Int)
}

final class StocksListTableViewCell: UITableViewCell {
    
    static let cellID = String(describing: self)
    
    private lazy var tickerLabel: UILabel = {
        let tickerLabel = UILabel()
        tickerLabel.translatesAutoresizingMaskIntoConstraints = false
        tickerLabel.font = UIFont(name: "Inter-Bold", size: 18)
        return tickerLabel
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Inter-Regular", size: 14)
        return nameLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StocksListTableViewCell: IStocksListTableViewCell {
    
    func config(stockInfo: StockShortInfo, number: Int) {
        self.clearCell()
        self.fillView(stockInfo: stockInfo)
        self.setBackgroundColor(number: number)
    }
}

private extension StocksListTableViewCell {
    
    private func clearCell() {
        self.tickerLabel.text = nil
        self.nameLabel.text = nil
    }
    
    private func fillView(stockInfo: StockShortInfo) {
        self.tickerLabel.text = stockInfo.ticker
        self.nameLabel.text = stockInfo.companyName
    }
    
    private func setBackgroundColor(number: Int) {
        if number % 2 == 0 {
            self.backgroundColor = UIColor(red: 0.941, green: 0.955, blue: 0.97, alpha: 1)
        }
        else {
            self.backgroundColor = .white
        }
    }
    
    private func setupConstraints() {
        self.constraintTickerLabel()
        self.constraintNameLabel()
    }
    
    private func constraintTickerLabel() {
        self.contentView.addSubview(tickerLabel)
        NSLayoutConstraint.activate([
            self.tickerLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.tickerLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.tickerLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14),
            self.tickerLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func constraintNameLabel() {
        self.contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.nameLabel.topAnchor.constraint(equalTo: self.tickerLabel.bottomAnchor),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -14)
        ])
    }
}
