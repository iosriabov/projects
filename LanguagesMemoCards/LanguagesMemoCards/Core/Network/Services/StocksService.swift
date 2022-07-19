//
//  StocksService.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 23.03.2022.
//

import Foundation

protocol StocksServiceProtocol {
    func fetchListOfWords(word: String, completion: @escaping (Swift.Result<ListOfWordsResponse, Error>) -> Void)
}

class StockService: StocksServiceProtocol {
    static let shared = StockService()
    private let network = NetworkCore.instance
}

extension StockService {
    func fetchListOfWords(word: String, completion: @escaping (Result<ListOfWordsResponse, Error>) -> Void) {
        let metadata = "api/v2/entries/en/\(word)"
        network.request(metadata: metadata) { result in
            completion(result)
        }
    }
}




