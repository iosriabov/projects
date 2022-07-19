//
//  NetworkCore.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 23.03.2022.
//

import Foundation

typealias CoreResult<T: Responsable> = Swift.Result<T, Error>

enum NetworkError: Error {
    case invalidURL
    case responseDecodingError
}

protocol NetworkCoreProtocol {
    func request<Res: Responsable>(metadata: String, completion: @escaping (CoreResult<Res>) -> Void)
}

class NetworkCore {
    static let instance: NetworkCoreProtocol = NetworkCore()
    
    private let url = "https://api.dictionaryapi.dev"
    private let jsonDecoder = JSONDecoder()
}

extension NetworkCore: NetworkCoreProtocol {
    func request<Res: Responsable>(metadata: String, completion: @escaping (CoreResult<Res>) -> Void) {
        guard let urlRequest = URL(string: "\(url)/\(metadata)") else {completion(.failure(NetworkError.invalidURL))
            return}
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                self.handleSuccessDataResponse(data, completion: completion)
            } else {
                print(completion(.failure(NetworkError.responseDecodingError)))
            }
        })
        dataTask.resume()
    }
}

extension NetworkCore {
    private func handleSuccessDataResponse<Res: Responsable>(_ data: Data, completion: (CoreResult<Res>) -> Void) {
        
        do {
            completion(.success(try decodeData(data: data)))
            
        } catch {
            completion(.failure(NetworkError.responseDecodingError))
        }
    }
    
    private func decodeData<Res: Responsable>(data: Data) throws -> Res {
        let response = try jsonDecoder.decode(Res.self, from: data)
        return response
    }
}

