//
//  NetworkManager.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 03.05.2024.
//

import Foundation


enum AppConfiguration: CaseIterable{
    case api
    case test
    case stage
    
    var url: URL {
        switch self {
        case .api:
            return URL(string: "https://swapi.dev/api/people/8")!
            
        case .test:
            return URL(string: "https://swapi.dev/api/starships/3")!
            
        case .stage:
            return URL(string: "https://swapi.dev/api/planets/5")!
            
        }
    }
}

struct NetworkManager{
    
    
    static func request(for configuration: AppConfiguration) {
        print("request")
        
        let tast = URLSession.shared.dataTask(with: configuration.url){ data, response, error in
            
            
            if let error = error {
                print(error.localizedDescription)
                print(error.localizedDescription.debugDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                return
            }
            
            print(response.statusCode)
            print(response.allHeaderFields)
            
            guard let data else {
                return
            }
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            
        }
        
        tast.resume()
        
    }
}
