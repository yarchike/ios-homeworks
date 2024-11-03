//
//  NetworkManagerTests.swift
//  NavigationTests
//
//  Created by Ярослав  Мартынов on 30.10.2024.
//

import Foundation
import XCTest
@testable import Navigation


class NetworkManagerTests: XCTestCase {
    var networkServiceMock: NetworkServiceMock!
    var networkManager: NetworkManager!
        
    override func setUp() {
         super.setUp()
         networkServiceMock = NetworkServiceMock()
         networkManager = NetworkManager(networkService: networkServiceMock)
     }
    
    override func tearDown() {
        networkServiceMock = nil
        networkManager = nil
        super.tearDown()
    }
    
    func testGetUser_withValidResponse_returnsTitle() {
         let jsonData = """
         {
             "title": "test"
         }
         """.data(using: .utf8)!
         
         networkServiceMock.fakeResult = .success(jsonData)
         networkManager.getUser { result in
             switch result {
             case .success(let title):
                 XCTAssertEqual(title, "test")
             case .failure:
                 XCTFail("Expected success but got failure")
             }
         }
     }
    func testGetUser_failureResponse() {
        networkServiceMock.fakeResult = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"]))

        networkManager.getUser { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Network error")
            }
        }
    }
    
    func testGetPlanet_successfulResponse() {
         let planetJsonData = """
         {
             "name": "Tatooine",
                "rotation_period": "23",
                "orbital_period": "304",
                "diameter": "10465",
                "climate": "arid",
                "gravity": "1",
                "terrain": "desert",
                "surface_water": "1",
                "population": "200000",
                "residents": [
                    "https://swapi.dev/api/people/1/",
                    "https://swapi.dev/api/people/2/"
                ],
                "films": [
                    "https://swapi.dev/api/films/1/"
                ],
                "created": "2014-12-09T13:50:49.641000Z",
                "edited": "2014-12-20T20:58:18.411000Z",
                "url": "https://swapi.dev/api/planets/1/"
         }
         """.data(using: .utf8)!

        networkServiceMock.fakeResult = .success(planetJsonData)

         networkManager.getPlanet { result in
             switch result {
             case .success(let planet):
                 XCTAssertEqual(planet.name, "Tatooine")
             case .failure:
                 XCTFail("Expected success but got failure")
             }
         }
     }
}
