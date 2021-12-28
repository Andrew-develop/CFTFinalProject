//
//  StocksListTableViewCell.swift
//  StocksApp
//
//  Created by Sergio Ramos on 26.12.2021.
//

import UIKit

protocol IStocksListTableViewCell {
    func config(stockInfo: StockBaseInfo, number: Int)
    func setImage(data: Data)
}

final class StocksListTableViewCell: UITableViewCell {
    
    static let cellID = String(describing: StocksListTableViewCell.self)
    
    private lazy var logo: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFit
        return logo
    }()
    
    private lazy var tickerLabel: UILabel = {
        let tickerLabel = UILabel()
        tickerLabel.translatesAutoresizingMaskIntoConstraints = false
        return tickerLabel
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
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
    
    func setImage(data: Data) {
        self.logo.image = UIImage(data: data)
    }
    
    func config(stockInfo: StockBaseInfo, number: Int) {
        self.clearCell()
        self.fillView(stockInfo: stockInfo)
        self.setBackgroundColor(number: number)
    }
}

private extension StocksListTableViewCell {
    
    private func clearCell() {
        self.logo.image = nil
        self.tickerLabel.text = nil
        self.nameLabel.text = nil
    }
    
    private func fillView(stockInfo: StockBaseInfo) {
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
        self.constraintLogo()
        self.constraintTickerLabel()
        self.constraintNameLabel()
    }
    
    private func constraintLogo() {
        contentView.addSubview(logo)
        NSLayoutConstraint.activate([
            self.logo.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.logo.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.logo.heightAnchor.constraint(equalToConstant: 52),
            self.logo.widthAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func constraintTickerLabel() {
        self.contentView.addSubview(tickerLabel)
        NSLayoutConstraint.activate([
            self.tickerLabel.leadingAnchor.constraint(equalTo: self.logo.trailingAnchor, constant: 12),
            self.tickerLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.tickerLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14),
            self.tickerLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func constraintNameLabel() {
        self.contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(equalTo: self.logo.trailingAnchor, constant: 12),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.nameLabel.topAnchor.constraint(equalTo: self.tickerLabel.bottomAnchor),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -14)
        ])
    }
}
