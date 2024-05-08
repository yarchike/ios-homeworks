//
//  NetworkManager.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 03.05.2024.
//

import Foundation


enum AppConfiguration: String, CaseIterable {
    case people = "https://swapi.dev/api/people"
    case starships = "https://swapi.dev/api/starships"
    case planets = "https://swapi.dev/api/planets"
    
    var url: URL? {
        URL(string: self.rawValue)
    }
}

struct NetworkManager{
    
    
    static func request(for configuration: AppConfiguration) {
        print("request")
        
        guard let url = configuration.url else {
            return
        }
        
        let tast = URLSession.shared.dataTask(with: url){ data, response, error in
            
            
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
    
    static func getUser(completion: @escaping (Result<String, Error>) -> Void){
        let urlString = "https://jsonplaceholder.typicode.com/todos/1"
        let url = URL(string: urlString)!
        
        let tast = URLSession.shared.dataTask(with: url){ data, response, error in
            
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
            
            do{
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let result = json?["title"] else{
                    return
                }
                completion(.success(result as? String ?? ""))
            }catch{
                print("Ошибка")
            }
            
        }
        
        tast.resume()
        
    }
}
