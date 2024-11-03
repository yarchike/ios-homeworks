//
//  NetworkServiceMock.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 30.10.2024.
//

import Foundation


class NetworkServiceMock: NetworkServiceProtocol{
    var fakeResult: Result<Data, Error>!
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        completion(fakeResult)
        }

}
