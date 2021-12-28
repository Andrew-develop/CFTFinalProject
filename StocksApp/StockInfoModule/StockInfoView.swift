//
//  StockInfoView.swift
//  StocksApp
//
//  Created by Sergio Ramos on 27.12.2021.
//

import UIKit

protocol IStockInfoView: UIView {

    var numberOfActions: (() -> Int?)? { get set }
    var getAction: ((Int) -> Action?)? { get set }
    var onCellSelect: ((Int) -> Void)? { get set }

    func updateCollectionView()
    func updatePrice(price: Price)
    func updateStockInfo(info: StockShortInfo)
    func updateImage(data: Data)
}

final class StockInfoView: UIView {
    
    var numberOfActions: (() -> Int?)?
    var getAction: ((Int) -> Action?)?
    var onCellSelect: ((Int) -> Void)?
    
    private lazy var logo: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    private lazy var tickerLabel: UILabel = {
        let tickerLabel = UILabel()
        tickerLabel.translatesAutoresizingMaskIntoConstraints = false
        tickerLabel.textAlignment = .center
        tickerLabel.font = UIFont(name: "Inter-Bold", size: 18)
        return tickerLabel
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "Inter-SemiBold", size: 16)
        return nameLabel
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textAlignment = .center
        priceLabel.font = UIFont(name: "Inter-Medium", size: 16)
        return priceLabel
    }()
    
    private lazy var priceChangeLabel: UILabel = {
        let priceChangeLabel = UILabel()
        priceChangeLabel.translatesAutoresizingMaskIntoConstraints = false
        priceChangeLabel.textAlignment = .center
        priceChangeLabel.font = UIFont(name: "Inter-Regular", size: 14)
        return priceChangeLabel
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(StockInfoCollectionViewCell.self, forCellWithReuseIdentifier: StockInfoCollectionViewCell.cellID)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StockInfoView: IStockInfoView {
    
    func updateCollectionView() {
        self.collectionView.reloadData()
    }
    
    func updateStockInfo(info: StockShortInfo) {
        self.nameLabel.text = info.companyName
        self.tickerLabel.text = info.ticker
    }
    
    func updatePrice(price: Price) {
        self.priceLabel.text = price.currentPrice + "$"
        self.priceChangeLabel.text = price.priceChange
        
        guard let value = Double(price.priceChange) else { return }
        self.applyColor(value: value)
    }
    
    func updateImage(data: Data) {
        self.logo.image = UIImage(data: data)
    }
}

private extension StockInfoView {
    
    private func configView() {
        self.backgroundColor = .white
        self.constraintLogo()
        self.constraintTickerLabel()
        self.constraintNameLabel()
        self.constraintPriceLabel()
        self.constraintPriceChangeLabel()
        self.constraintCollectionView()
    }
    
    private func constraintLogo() {
        self.addSubview(self.logo)
        NSLayoutConstraint.activate([
            self.logo.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.logo.heightAnchor.constraint(equalToConstant: 50),
            self.logo.widthAnchor.constraint(equalToConstant: 50),
            self.logo.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func constraintTickerLabel() {
        self.addSubview(self.tickerLabel)
        NSLayoutConstraint.activate([
            self.tickerLabel.topAnchor.constraint(equalTo: self.logo.bottomAnchor, constant: 16),
            self.tickerLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.03),
            self.tickerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.tickerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    private func constraintNameLabel() {
        self.addSubview(self.nameLabel)
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.tickerLabel.bottomAnchor),
            self.nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.05),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    private func constraintPriceLabel() {
        self.addSubview(self.priceLabel)
        NSLayoutConstraint.activate([
            self.priceLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 16),
            self.priceLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.04),
            self.priceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    private func constraintPriceChangeLabel() {
        self.addSubview(self.priceChangeLabel)
        NSLayoutConstraint.activate([
            self.priceChangeLabel.topAnchor.constraint(equalTo: self.priceLabel.bottomAnchor),
            self.priceChangeLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.06),
            self.priceChangeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.priceChangeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    private func constraintCollectionView() {
        self.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.priceChangeLabel.bottomAnchor, constant: 16),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func applyColor(value: Double) {
        if value > 0 {
            self.priceChangeLabel.textColor = .green
        } else if value < 0 {
            self.priceChangeLabel.textColor = .red
        } else {
            self.priceChangeLabel.textColor = .black
        }
    }
}

extension StockInfoView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onCellSelect?(indexPath.row)
    }
}

extension StockInfoView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.numberOfActions?() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: StockInfoCollectionViewCell.cellID, for: indexPath) as? StockInfoCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        if let action = self.getAction?(indexPath.row) {
            cell.config(action: action)
        }

        return cell
    }
}

extension StockInfoView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width / 2 - 8,
                      height: self.collectionView.bounds.height / 3 - 8)
    }
}



