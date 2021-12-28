//
//  NewsView.swift
//  StocksApp
//
//  Created by Sergio Ramos on 28.12.2021.
//

import UIKit

protocol INewsView: UIView {
    
    var numberOfArticles: (() -> Int?)? { get set }
    var getArticle: ((Int) -> Article?)? { get set }
    
    func update()
}

final class NewsView: UIView {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.cellID)
        tableView.allowsSelection = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var numberOfArticles: (() -> Int?)?
    var getArticle: ((Int) -> Article?)?

}

extension NewsView: INewsView {
    
    func update() {
        self.tableView.reloadData()
    }
    
}

private extension NewsView {
    
    private func configView() {
        self.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension NewsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}

extension NewsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.numberOfArticles?() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.cellID) as? NewsTableViewCell
        else {
            return UITableViewCell()
        }

        if let article = self.getArticle?(indexPath.row) {
            cell.config(article: article)
        }

        return cell
    }
    
}
