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

struct NetworkManager {
    
    static let shared = NetworkManager(networkService: NetworkService())
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func request(for configuration: AppConfiguration) {
        print("request")
        
        guard let url = configuration.url else {
            return
        }
        
        networkService.fetchData(from: url, completion: {result in})
        
        
    }
    
    func getUser(completion: @escaping (Result<String, Error>) -> Void){
        let urlString = "https://jsonplaceholder.typicode.com/todos/1"
        let url = URL(string: urlString)!
        
        
        networkService.fetchData(from: url){result in
            switch result{
            case .success(let data):
                do{
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    guard let result = json?["title"] else{
                        return
                    }
                    completion(.success(result as? String ?? ""))
                }catch{
                    print("Ошибка")
                }
            case .failure(let error):
                completion(.failure(error))
            }

        }
    }
    
    func getPlanet(completion: @escaping (Result<Planet, Error>) -> Void){
        
        let urlString = "https://swapi.dev/api/planets/1"
        let url = URL(string: urlString)!
        

        networkService.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                do {
                    let planet = try JSONDecoder().decode(Planet.self, from: data)
                    completion(.success(planet))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    
    func getResidentsPlanet(planet: Planet, completion: @escaping (Result<[ResidentPlanet], Error>) -> Void){
        var residents = [ResidentPlanet]()
        var count = planet.residents.count
        planet.residents.forEach{ urlResindet in
            self.getResidentPlanet(urlString: urlResindet){ result in
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
    
    func getResidentPlanet(urlString: String, completion: @escaping (Result<ResidentPlanet, Error>) -> Void){
    
        let url = URL(string: urlString)!
        
        networkService.fetchData(from: url){ result in
            switch result {
            case .success(let data):
                do{
                    let residentPlanet = try JSONDecoder().decode(ResidentPlanet.self, from: data)
                    completion(.success(residentPlanet))
                }catch{
                    print("Ошибка")
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
        
    }
        
}
