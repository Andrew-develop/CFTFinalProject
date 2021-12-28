//
//  StockInfoTableViewCell.swift
//  StocksApp
//
//  Created by Sergio Ramos on 27.12.2021.
//

import UIKit

protocol INewsTableViewCell {
    func config(article: Article)
}

final class NewsTableViewCell: UITableViewCell {
    
    static let cellID = String(describing: self)
    
    private lazy var picture: UIImageView = {
        let picture = UIImageView()
        picture.translatesAutoresizingMaskIntoConstraints = false
        return picture
    }()
    
    private lazy var headlineLabel: UILabel = {
        let tickerLabel = UILabel()
        tickerLabel.translatesAutoresizingMaskIntoConstraints = false
        return tickerLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewsTableViewCell: INewsTableViewCell {
    
    func config(article: Article) {
        self.clearCell()
        self.fillView(article: article)
    }
}

private extension NewsTableViewCell {
    
    private func clearCell() {
        self.headlineLabel.text = nil
        self.dateLabel.text = nil
        self.textView.text = nil
        self.picture.image = nil
    }
    
    private func fillView(article: Article) {
    }
    
    private func setupConstraints() {
        self.constraintPicture()
        self.constraintHeadlineLabel()
        self.constraintDateLabel()
        self.constraintTextView()
    }
    
    private func constraintPicture() {
        self.contentView.addSubview(self.picture)
        NSLayoutConstraint.activate([
            self.picture.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.picture.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.picture.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14),
            self.picture.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func constraintHeadlineLabel() {
        self.contentView.addSubview(self.headlineLabel)
        NSLayoutConstraint.activate([
            self.headlineLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.headlineLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.headlineLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14),
            self.headlineLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func constraintDateLabel() {
        self.contentView.addSubview(self.dateLabel)
        NSLayoutConstraint.activate([
            self.dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.dateLabel.topAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -14)
        ])
    }
    
    private func constraintTextView() {
        self.contentView.addSubview(self.textView)
        NSLayoutConstraint.activate([
            self.textView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.textView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.textView.topAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -14)
        ])
    }
}

