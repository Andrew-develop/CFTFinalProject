//
//  StockInfoCollectionViewCell.swift
//  StocksApp
//
//  Created by Sergio Ramos on 27.12.2021.
//

import UIKit

protocol IStockInfoCollectionViewCell {
    func config(action: Action)
}

final class StockInfoCollectionViewCell: UICollectionViewCell {
    
    static let cellID = String(describing: self)
    
    private lazy var picture: UIImageView = {
        let picture = UIImageView()
        picture.translatesAutoresizingMaskIntoConstraints = false
        picture.contentMode = .scaleAspectFit
        return picture
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Inter-Medium", size: 16)
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.constraintNameLabel()
        self.constraintPicture()
    }
}

extension StockInfoCollectionViewCell: IStockInfoCollectionViewCell {
    
    func config(action: Action) {
        self.nameLabel.text = action.description
        self.picture.image = UIImage(named: action.description)
    }
}

private extension StockInfoCollectionViewCell {
    
    func constraintPicture() {
        self.contentView.addSubview(self.picture)
        NSLayoutConstraint.activate([
            self.picture.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.picture.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.picture.bottomAnchor.constraint(equalTo: self.nameLabel.topAnchor),
            self.picture.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        ])
    }
    
    func constraintNameLabel() {
        self.contentView.addSubview(self.nameLabel)
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.nameLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.1)
        ])
    }
}
