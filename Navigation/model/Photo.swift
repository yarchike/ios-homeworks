//
//  Photo.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 04.02.2024.
//

struct Photo {
    let id: Int
    let image: String
}


extension Photo {
    static func make() -> [Photo] {
           (1...20).map { Photo(id: $0, image: String($0)) }
       }
}
