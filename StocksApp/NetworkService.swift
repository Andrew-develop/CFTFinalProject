//
//  NetworkService.swift
//  StocksApp
//
//  Created by Sergio Ramos on 27.12.2021.
//

import Foundation

protocol INetworkService {
    func loadData<T: Decodable>(path: String, queryItems: [URLQueryItem]?, completion: @escaping (Result<T, Error>) -> Void)
    func loadImage(url: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkService {
    
    private let session: URLSession
    private let tokenQueryItem = URLQueryItem(name: "token", value: "c0nngcn48v6t5mebit5g")
    private let baseURL = "https://finnhub.io/api/v1/"

    init(configuration: URLSessionConfiguration? = nil) {
        if let configuration = configuration {
            self.session = URLSession(configuration: configuration)
        }
        else {
            self.session = URLSession(configuration: URLSessionConfiguration.default)
        }
    }
}

extension NetworkService: INetworkService {
    
    func loadData<T: Decodable>(path: String, queryItems: [URLQueryItem]?, completion: @escaping (Result<T, Error>) -> Void) {
        
        let url: URL
        
        guard let queryItems = queryItems else {
            guard let possibleURL = URL(string: baseURL + path) else { return }
            url = possibleURL
            return
        }

        var urlComps = URLComponents(string: baseURL + path)
        urlComps?.queryItems = queryItems
        urlComps?.queryItems?.append(tokenQueryItem)
        
        guard let possibleURL = urlComps?.url else { return }
        url = possibleURL
        
        let request = URLRequest(url: url)
        self.session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    
    func loadImage(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        
        self.session.downloadTask(with: request) { url, response, error in
            if let error = error {
                completion(.failure(error))
            }
            if let url = url {
                if let result = try? Data(contentsOf: url) {
                    completion(.success(result))
                }
            }
        }
    }
}
