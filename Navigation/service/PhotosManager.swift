//
//  PhotosService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 10.12.2024.
//

import Foundation
import UIKit

class PhotosManager {
    
    static let shared = PhotosManager()
    

    private init() {}
    
    func fetchPhotosByAuthor(completion: @escaping ([Photo]) -> Void) {
        if let user = CurrentUser.shared.user{
            FirebaseDataBaseService.shared.fetchPhotosByAuthorId(authorId: user.id, completion: completion)
        }
       
    }
    
    func addPhoto(image: UIImage, completion: @escaping (Result<String, Error>) -> Void){
        FirebaseStorageService.shared.uploadImage(image: image){ result in
            switch result {
            case .success(let url):
                let photo = Photo(id:UUID().uuidString, imageURL: url, authorId: CurrentUser.shared.user?.id ?? "")
                FirebaseDataBaseService.shared.addPhotoToDatabase(photo: photo)
                completion(.success(url))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
        
    }
    
    
}
