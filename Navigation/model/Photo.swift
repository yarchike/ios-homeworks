//
//  Photo.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 04.02.2024.
//

struct Photo {
    let id: String
    let imageURL: String
    let authorId: String
    
    
    func toDictionary() -> [String: Any] {
         return [
             "id": id,
             "imageURL": imageURL,
             "authorId": authorId
         ]
     }
}


extension Photo {
    static func make() -> [Photo] {
            return []
       }
}
