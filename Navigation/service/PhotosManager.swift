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
    
    func fetchPhotosByAuthorId(authorId: String, completion: @escaping ([Photo]) -> Void) {
        FirebaseDataBaseService.shared.fetchPhotosByAuthorId(authorId: authorId, completion: completion)
    }
    
    func addPhoto(image: UIImage){
        FirebaseStorageService.shared.uploadImage(image: image){result in
            switch result {
            case .success(let imagePatch):
                let photo = Photo(id: UUID().uuidString, imageURL: imagePatch, authorId: CurrentUser.shared.user?.id ?? "")
                FirebaseDataBaseService.shared.addPhotoToDatabase(photo: photo)
            case .failure(_):
                break
            }
        }
        
    }
    
    
}
