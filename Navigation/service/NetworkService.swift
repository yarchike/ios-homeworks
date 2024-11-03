//
//  NetworkService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 30.10.2024.
//

import Foundation


class NetworkService: NetworkServiceProtocol{
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                completion(.success(data))
            }
            
            task.resume()
        }

}
