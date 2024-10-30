//
//  NetworkServiceProtocol.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 30.10.2024.
//

import Foundation


protocol NetworkServiceProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
