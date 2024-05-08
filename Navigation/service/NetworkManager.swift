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
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                return
            }
            
            guard let data else {
                return
            }
            let str = String(decoding: data, as: UTF8.self)
            
        }
        
        tast.resume()
        
    }
    
    static func getUser(completion: @escaping (Result<String, Error>) -> Void){
        let urlString = "https://jsonplaceholder.typicode.com/todos/1"
        let url = URL(string: urlString)!
        
        let tast = URLSession.shared.dataTask(with: url){ data, response, error in
            
            if let error = error {

                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                return
            }
            

            
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
    
    static func getPlanet(completion: @escaping (Result<Planet, Error>) -> Void){
        
        let urlString = "https://swapi.dev/api/planets/1"
        let url = URL(string: urlString)!
        
        let tast = URLSession.shared.dataTask(with: url){ data, response, error in
            
            if let error = error {
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                return
            }
    
            
            guard let data else {
                return
            }
            
            do{
                let planet = try JSONDecoder().decode(Planet.self, from: data)
                completion(.success(planet))
            }catch{
                print("Ошибка")
            }
            
        }
        
        tast.resume()
        
    }
    
    
    static func getResidentsPlanet(planet: Planet, completion: @escaping (Result<[ResidentPlanet], Error>) -> Void){
        var residents = [ResidentPlanet]()
        var count = planet.residents.count
        planet.residents.forEach{ urlResindet in
            getResidentPlanet(urlString: urlResindet){ result in
                switch result{
                    
                case .success(let resident):
         
                    residents.append(resident)
                case .failure(_): break
                    
                }
                count-=1
                if(count == 0){
                    completion(.success(residents))
                }
            }
            
        }
       
    }
    
    static func getResidentPlanet(urlString: String, completion: @escaping (Result<ResidentPlanet, Error>) -> Void){
    
        let url = URL(string: urlString)!
        
        let tast = URLSession.shared.dataTask(with: url){ data, response, error in
            
            if let error = error {
                return
            }
            
            guard let response = response as? HTTPURLResponse else{
                return
            }
            
            guard let data else {
                return
            }
            
            do{
                let residentPlanet = try JSONDecoder().decode(ResidentPlanet.self, from: data)
                completion(.success(residentPlanet))
            }catch{
                print("Ошибка")
            }
            
        }
        
        tast.resume()
        
        
    }
        
}
