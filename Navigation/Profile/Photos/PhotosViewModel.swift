//
//  PhotosViewModel.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 10.12.2024.
//

import Foundation

import UIKit

class PhotosViewModel {
    
    // MARK: - Properties
    private(set) var photos: [Photo] = []
    private(set) var processedImages: [UIImage] = []
    
    var onImagesUpdated: (() -> Void)?
    
    // MARK: - Methods
    
    func fetchPhotos() {
        PhotosManager.shared.fetchPhotosByAuthor{result in
            self.photos = result
            self.onImagesUpdated?()
        }
       
    }
    
    
    func addPhoto(image: UIImage) {
        PhotosManager.shared.addPhoto(image: image){error in
            if error != nil{
                return
            }
            self.fetchPhotos()
        }
        
    }
}
