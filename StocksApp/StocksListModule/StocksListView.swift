//
//  StocksListView.swift
//  StocksApp
//
//  Created by Sergio Ramos on 26.12.2021.
//

import UIKit

protocol IStocksListView: UIView {
    
    var onTouchSearchButton: ((String) -> Void)? { get set }
    var onSearchTextEmpty: (() -> Void)? { get set }
    var onSelectCell: ((Int) -> Void)? { get set }
    var numberOfStocks: (() -> Int?)? { get set }
    var getStockInfo: ((Int) -> StockShortInfo?)? { get set }

    func update()
    func showIndicator()
}

final class StocksListView: UIView {
    
    var onTouchSearchButton: ((String) -> Void)?
    var onSearchTextEmpty: (() -> Void)?
    var onSelectCell: ((Int) -> Void)?
    var numberOfStocks: (() -> Int?)?
    var getStockInfo: ((Int) -> StockShortInfo?)?
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Find company or ticker"
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.borderStyle = .none
        searchBar.layer.borderWidth = 0.33
        searchBar.layer.borderColor = UIColor.black.cgColor
        searchBar.layer.cornerRadius = 16
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StocksListTableViewCell.self, forCellReuseIdentifier: StocksListTableViewCell.cellID)
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StocksListView: IStocksListView {
    
    func update() {
        self.activityIndicator.stopAnimating()
        self.tableView.reloadData()
    }
    
    func showIndicator() {
        self.activityIndicator.startAnimating()
    }
}

private extension StocksListView {
    
    @objc private func dismissKeyboard() {
        self.searchBar.resignFirstResponder()
    }
    
    private func configView() {
        self.backgroundColor = .white
        self.constraintSearchBar()
        self.constraintTableView()
        self.constraintActivityIndicator()
    }
    
    private func constraintSearchBar() {
        self.addSubview(searchBar)
        NSLayoutConstraint.activate([
            self.searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.searchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.searchBar.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.04)
        ])
    }
    
    private func constraintTableView() {
        self.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 8),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func constraintActivityIndicator() {
        self.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

extension StocksListView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.dismissKeyboard()
        guard let text = searchBar.text else { return }
        self.onTouchSearchButton?(text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.onSearchTextEmpty?()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.addGestureRecognizer(self.tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.removeGestureRecognizer(self.tapRecognizer)
    }
}

extension StocksListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.onSelectCell?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        68
    }
}

extension StocksListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.numberOfStocks?() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StocksListTableViewCell.cellID) as? StocksListTableViewCell
        else {
            return UITableViewCell()
        }
        
        if let stockInfo = self.getStockInfo?(indexPath.row) {
            cell.config(stockInfo: stockInfo, number: indexPath.row)
        }
        
        cell.layer.cornerRadius = 8
        
        return cell
    }
}

